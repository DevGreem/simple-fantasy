extends AnimatedSprite2D

class_name CombatEntity

signal on_play()

var team: CombatTeam
@export var entity_name: String
var was_played: bool = false:
	set(value):
		
		was_played = value
		if value:
			on_play.emit()


@export_category("Stats")
@export var hp: int = 1:
	get:
		return hp
	set(value):
		
		if value <= 0:
			self._die()
		else:
			hp = value

@export var dmg: IntRange = IntRange.create(0, 1)
@export var def: int = 0
var blocking: bool = false:
	set(value):
		
		print("Setting blocking to: ", value)
		blocking = value

func get_actions() -> Array[ActionBase]:
	var actions_container: ActionsContainer = get_node("ActionsContainer")
	
	return actions_container.actions

func attack(enemy_index: int) -> void:
	_attack_animation()
	self.team.enemies_team.get_ally(enemy_index).get_damage(self)
	prints("Attacking enemy on index ", enemy_index)

func get_damage(entity: CombatEntity) -> void:
	
	var damage = randi_range(entity.dmg.min_value, entity.dmg.max_value) - (self.def if self.blocking else 0) 
	
	self.hp -= damage
	var damage_label: DamageLabel = DamageLabel.new()
	add_child(damage_label)
	damage_label.set_dmg(damage)
	
	prints("Received ", damage, " points of damage")

func _die() -> void:
	self.queue_free()

func _on_change_turn(_new_turn: int):
	self.blocking = false

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
