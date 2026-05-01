extends AnimatedSprite2D

class_name CombatEntity

signal on_play
signal on_reset_play

var team: CombatTeam
var was_played: bool = false:
	set(value):
		
		was_played = value
		if value:
			on_play.emit()
		else:
			on_reset_play.emit()

@export var stats: EntityData:
	set(value):
		
		stats = value
		_init_stats()

var blocking: bool = false:
	set(value):
		
		#print("Setting blocking to: ", value)
		blocking = value

func _ready():
	self.stats = stats.duplicate(true)
	self.animation_finished.connect(self._on_animation_finished)
	self.animation = "idle"
	self.play()
	prints("Loaded entity: \n", self.stats, "\n")

func _init_stats() -> void:
	
	if not stats:
		return
	
	self.sprite_frames = stats.combat_sprite
	
	if not self.stats.on_die.is_connected(_die):
		self.stats.on_die.connect(_die)

func attack(enemy: CombatEntity) -> void:
	enemy.get_damage(self)
	_attack_animation()
	self.play("attacking")
	#prints("Attacking enemy on index ", enemy_index)

func get_damage(entity: CombatEntity) -> void:
	
	#prints("Received dmg stats: ", entity.dmg.min_value, " ", entity.dmg.max_value)
	var damage = max(
		0,
		entity.stats.dmg.gen_num() - (self.stats.def.gen_num() if self.blocking else 0)
	)
	
	prints("Received damage: ", damage)
	
	self.stats.hp -= damage
	
	_on_damaged(damage)
	
	#prints("Received ", damage, " points of damage")

func receive_damage(dmg: int) -> void:
	self.stats.hp -= dmg
	_on_damaged(dmg)

func _on_damaged(damage: int):
	if is_alive():
		self.play("damaged")
	
	_show_received_label(damage)

func heal(target: CombatEntity, healed: int, can_revive := false) -> void:
	target.receive_heal(healed, can_revive)

func receive_heal(healed: int, can_revive := false) -> void:
	set_heal(healed, can_revive)

func set_heal(healed: int, can_revive := false) -> void:
	
	if is_alive() or can_revive:
		self.stats.hp += healed
		_show_received_label(healed)

func _show_received_label(received: int) -> void:
	var damage_label: DamageLabel = DamageLabel.new()
	damage_label.scale = Vector2(0.5, 0.5)
	add_child(damage_label)
	damage_label.set_dmg(received)

func cast_spell(spell: Spell, targets: Array[CombatEntity]):
	
	if spell.mana_cost <= self.stats.mana:
		self.stats.mana -= spell.mana_cost
		spell.apply_effects(self, targets)

func block() -> void:
	self.blocking = true
	self.play("blocking")

func unblock() -> void:
	self.blocking = false
	self.play("idle")

func _die() -> void:
	self.play("downed")

func _on_change_turn(_new_turn: int):
	pass

func convert_flip_h() -> int:
	
	if flip_h == false:
		return -1
	
	return flip_h

func convert_flip_v() -> int:
	if flip_v == false:
		return -1
	
	return flip_v

func convert_flips() -> Vector2i:
	
	var flip_vector := Vector2i(int(flip_h), int(flip_v))
	
	if flip_vector.x == 0:
		flip_vector.x = -1
	if flip_vector.y == 0:
		flip_vector.y = -1
	
	return flip_vector

func _attack_animation():
	var start = position
	var target = Vector2(start.x-(100*-convert_flip_h()), start.y)
	var peak_height := 20.0
	var tween = create_tween()
	
	tween.tween_method(func(t):
		var p = lerp(start, target, t)
		p.y -= sin(t*PI) * peak_height
		position = p
	, 0.0, 1.0, 0.1)
	
	tween.tween_method(func(t):
		position = target.lerp(start, t)
	, 0.0, 1.0, 0.15)
	
	await tween.finished

func _on_animation_finished() -> void:
	
	#prints("Finished animation:", animation)
	
	if animation == "downed":
		#prints("Executing died")
		await get_tree().create_timer(0.4).timeout
		self.play("died")
		return
	
	if animation == "died":
		#prints("Totally died")
		return
	
	if blocking:
		self.play("blocking")
		return
	
	#prints("Executing idle")
	self.play("idle")

func is_alive() -> bool:
	return self.stats.hp > 0
