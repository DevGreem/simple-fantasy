extends Resource

class_name AnimatedResource

@export var animation: SpriteFrames
@export var scale := Vector2(1, 1)
@export var sound: AudioStream

func _load_animation() -> AnimatedSprite2D:
	
	if not animation:
		return
	
	var sprite := AnimatedSprite2D.new()
	sprite.sprite_frames = self.animation
	sprite.animation_finished.connect(func(): sprite.queue_free())
	sprite.scale = scale
	
	return sprite

func _load_sound() -> AudioStreamPlayer2D:
	
	if not sound:
		return
	
	var stream := AudioStreamPlayer2D.new()
	stream.stream = sound
	stream.bus = "effects"
	
	return stream

func _make_effect_in(node: Node):
	
	
	var sprite := _load_animation()
	
	var stream: AudioStreamPlayer2D
	if sound:
		stream = _load_sound()
		node.add_child(stream)
		stream.play()
	
	node.add_child(sprite)
	sprite.play()
	await sprite.animation_finished
	node.remove_child(sprite)
	
	if stream:
		node.remove_child(stream)
