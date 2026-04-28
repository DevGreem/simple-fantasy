extends TextureRect

class_name ArrowPointer

enum PointingDirection {
	UP = 90,
	LEFT = 180,
	RIGHT = 0,
	DOWN = 270
}

@onready var original_pos = self.global_position

@export var flip: Vector2i = Vector2i(1, 1):
	set(value):
		
		if abs(value.x) == 1 and abs(value.y) == 1:
			flip = value

@export var offset: Vector2 = Vector2(100, 0)

func point_to(
	node: CanvasItem,
	pointing := PointingDirection.RIGHT,
	custom_offset := self.offset,
	custom_flip := self.flip
) -> void:
	point_position(
		node.global_position,
		pointing,
		custom_offset,
		custom_flip
	)

func point_position(
	position_to_point: Vector2,
	pointing := PointingDirection.RIGHT,
	custom_offset := self.offset,
	custom_flip := self.flip
) -> void:
	
	if pointing:
		self.rotation_degrees = pointing
	
	var new_arrow_pos = position_to_point - custom_offset
	
	new_arrow_pos -= Vector2(
		self.size.x/(int(is_pointing_on_y(pointing))+1),
		self.size.y/(int(is_pointing_on_x(pointing))+1)
	)
	
	self.flip_h = custom_flip.x
	self.flip_v = custom_flip.y
	
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

func is_pointing_on_x(pointing: PointingDirection) -> bool:
	return pointing == PointingDirection.RIGHT or pointing == PointingDirection.LEFT

func is_pointing_on_y(pointing: PointingDirection) -> bool:
	return pointing == PointingDirection.UP or pointing == PointingDirection.DOWN
