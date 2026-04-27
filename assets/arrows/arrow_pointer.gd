extends TextureRect

class_name ArrowPointer

@onready var original_pos = self.global_position

@export var direction: Vector2i = Vector2i(1, 1):
	set(value):
		
		if abs(value.x) == 1 and abs(value.y) == 1:
			direction = value

@export var offset: Vector2 = Vector2(100, 0)

func point_to(node: CanvasItem, custom_direction: Vector2i = self.direction) -> void:
	
	var new_arrow_pos = node.global_position - Vector2(self.size.x, self.size.y/2) - offset
	
	self.flip_h = custom_direction.x
	self.flip_v = custom_direction.y
	
	self.global_position = new_arrow_pos
	self.show()

func point_rect(node: Rect2, custom_direction: Vector2i = self.direction):
	
	var new_arrow_pos = node.position - Vector2(self.size.x, self.size.y/2) - offset
	
	self.flip_h = custom_direction.x
	self.flip_v = custom_direction.y
	
	self.global_position = new_arrow_pos
	self.show()

func unpoint() -> void:
	self.hide()
	self.global_position = original_pos
