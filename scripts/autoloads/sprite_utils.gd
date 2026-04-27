extends Node

func get_actual_frame(sprite: AnimatedSprite2D) -> Texture2D:
	
	var texture := sprite.sprite_frames.get_frame_texture(
		sprite.animation,
		sprite.frame
	)
	
	return texture
