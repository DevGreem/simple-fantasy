extends Label

class_name DamageLabel

@onready var parent: CombatEntity = get_parent()

func _ready():
	
	self.vertical_alignment = VERTICAL_ALIGNMENT_FILL
	self.horizontal_alignment = HORIZONTAL_ALIGNMENT_FILL
	
	await get_tree().process_frame
	
	var up: Tween = create_tween()
	up.tween_property(self, "position", position + Vector2(0, -20), 0.3)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	await up.finished
	queue_free()

func set_dmg(dmg: int) -> void:
	
	self.text = str(dmg)
	
	var texture = Sprite2DUtils.get_actual_frame(self.parent)
	self.global_position = self.parent.global_position - Vector2(0, texture.get_size().y/2+self.size.y)

#func get_damage(entity: Entity) -> void:
	#
	#var damage = randi_range(entity.dmg.min_value, entity.dmg.max_value) - (self.def if self.blocking else 0) 
	#
	#self.hp -= damage
	#var damage_label: Label = Label.new()
	#damage_label.text = str(damage)
	#damage_label.global_position = self.global_position - Vector2(0, damage_label.size.y)
	#add_child(damage_label, false, Node.INTERNAL_MODE_FRONT)
	#damage_label.show()
	#
	#prints("Received ", damage, " points of damage")
