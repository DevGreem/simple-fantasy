extends AnimatedSprite2D

class_name CombatEntity

signal on_play
signal on_reset_play

var team: CombatTeam
@export var entity_name: String
var was_played: bool = false:
	set(value):
		
		was_played = value
		if value:
			on_play.emit()
		else:
			on_reset_play.emit()


@export_category("Stats")
@export var hp: int = 1:
	get:
		return hp
	set(value):
		
		if value <= 0:
			hp = 0
			self._die()
			return
			#print_rich('**Character ', self, ' Died**')
		else:
			hp = value
			

@export var dmg: IntRange = IntRange.create(0, 1)
@export var def: int = 0
var blocking: bool = false:
	set(value):
		
		#print("Setting blocking to: ", value)
		blocking = value

func _ready():
	self.animation_finished.connect(self._on_animation_finished)
	self.play("idle")

func get_actions() -> Array[ActionBase]:
	var actions_container: ActionsContainer = get_node("ActionsContainer")
	
	return actions_container.actions

func attack(enemy: CombatEntity) -> void:
	enemy.get_damage(self)
	_attack_animation()
	self.play("attacking")
	#prints("Attacking enemy on index ", enemy_index)

func get_damage(entity: CombatEntity) -> void:
	
	#prints("Received dmg stats: ", entity.dmg.min_value, " ", entity.dmg.max_value)
	var damage = max(0, entity.dmg.gen_num() - (self.def if self.blocking else 0))
	if self.blocking:
		self.unblock()
	
	self.hp -= damage
	
	if is_alive():
		self.play("damaged")
	
	var damage_label: DamageLabel = DamageLabel.new()
	add_child(damage_label)
	damage_label.set_dmg(damage)
	
	#prints("Received ", damage, " points of damage")

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

func _on_animation_finished() -> void:
	
	prints("Finished animation:", animation)
	
	if animation == "downed":
		prints("Executing died")
		await get_tree().create_timer(0.2).timeout
		self.stop()
		self.animation = "died"
		self.play()
		return
	
	if animation == "died":
		prints("Totally died")
		return
	
	prints("Executing idle")
	self.stop()
	self.animation = "idle"
	self.play()

func is_alive() -> bool:
	return hp > 0
