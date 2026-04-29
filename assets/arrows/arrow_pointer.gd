extends TextureRect

class_name ArrowPointer

enum PointingDirection {
	UP = 90,
	LEFT = 180,
	RIGHT = 0,
	DOWN = 270
}

enum Sides {
	UP,
	LEFT,
	RIGHT,
	DOWN,
	CENTER
}

@onready var original_pos = self.global_position

@export var offset := Vector2(0, 0)
@export var pointing := PointingDirection.RIGHT
@export var at_his := Sides.UP 
@export var object: Node

func change_object(
	node: Node
):
	self.object = node

func select_object(
	node: Node,
	custom_pointing: PointingDirection = self.pointing,
	custom_at_his: Sides = self.at_his,
	custom_offset: Vector2 = self.offset
) -> void:
	self.object = node
	self.pointing = custom_pointing
	self.offset = custom_offset
	self.at_his = custom_at_his

func _process(_delta) -> void:
	
	if not object:
		return
	
	if is_pointing_on_y(self):
		self.rotation_degrees = pointing
	else:
		self.flip_h = pointing == PointingDirection.LEFT 
	
	var object_size: Vector2
	
	if object is AnimatedSprite2D:
		object_size = object.sprite_frames.get_frame_texture(object.animation, object.frame).get_size()
	else:
		object_size = object.size
	
	var new_arrow_pos = self.object.global_position + self.offset
	new_arrow_pos += object_size / 2 * Vector2(
		x_direction(self),
		y_direction(self)
	)
	
	# Centralize the arrow
	#new_arrow_pos -= Vector2(
		#self.size.x/(int(is_pointing_on_y(self))+1),
		#self.size.y/(int(is_pointing_on_x(self))+1)
	#)
	
	# Desplazar la flecha según su propio tamaño para que la PUNTA de la flecha toque el borde
	# Dado que el TextureRect tiene el origen arriba a la izquierda (0,0)
	if at_his == Sides.RIGHT:
		# Si está a la derecha apuntando hacia la izquierda, no se resta X porque la punta ya está en el borde izquierdo de su propia rect.
		new_arrow_pos.y -= self.size.y / 2.0 
	elif at_his == Sides.LEFT:
		# Si está a la izquierda apuntando a la derecha, se le resta su tamaño para que la punta derecha coincida
		new_arrow_pos.x -= self.size.x
		new_arrow_pos.y -= self.size.y / 2.0 
	elif at_his == Sides.UP:
		new_arrow_pos.x -= self.size.x / 2.0
		new_arrow_pos.y -= self.size.y
	elif at_his == Sides.DOWN:
		new_arrow_pos.x -= self.size.x / 2.0
		# no restamos en Y porque la punta estaría arriba
	
	self.global_position = new_arrow_pos

static func is_pointing_on_x(arrow: ArrowPointer) -> bool:
	return arrow.pointing == PointingDirection.RIGHT or arrow.pointing == PointingDirection.LEFT

static func is_pointing_on_y(arrow: ArrowPointer) -> bool:
	return arrow.pointing == PointingDirection.UP or arrow.pointing == PointingDirection.DOWN

static func x_direction(arrow: ArrowPointer) -> int:
	
	if is_on_x(arrow):
		
		if arrow.at_his == Sides.LEFT:
			return -1
		
		return 1
	
	return 0

static func y_direction(arrow: ArrowPointer) -> int:
	
	if is_on_y(arrow):
		
		if arrow.at_his == Sides.UP:
			return -1
		
		return 1
	
	return 0

static func is_on_x(arrow: ArrowPointer) -> bool:
	return arrow.at_his == Sides.LEFT or arrow.at_his == Sides.RIGHT

static func is_on_y(arrow: ArrowPointer) -> bool:
	return arrow.at_his == Sides.UP or arrow.at_his == Sides.DOWN
