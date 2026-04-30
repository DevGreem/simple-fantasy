extends Node

func start_combat(player_team: Array[EntityData]):
	
	var combat_scene: PackedScene = load("res://scenes/combat/combat.tscn")
	
	var instance := combat_scene.instantiate()
	
	_load_player_team(instance, player_team)
	_load_enemy_team(instance)
	
	prints("Loaded combat")
	
	get_tree().change_scene_to_node(instance)

func _generate_enemies() -> void:
	return

func _load_player_team(instance: Node, player_team: Array[EntityData]) -> void:
	
	var player_node: PlayerTeam = instance.get_node("World/PlayerTeam")
	
	var BASE_POSITION := Vector2(
		get_viewport().get_visible_rect().size.x-300,
		150
	)
	var offset := Vector2(0, 0)
	
	for character in player_team:
		var entity := PlayableEntity.new()
		entity.stats = character
		entity.scale = Vector2(3, 3)
		player_node.add_child(entity)
		entity.global_position = BASE_POSITION + offset
		offset += Vector2(-20, entity.sprite_frames.get_frame_texture(entity.animation, entity.frame).get_size().y+75)

func _load_enemy_team(instance: Node) -> void:
	
	var enemy_node: AITeam = instance.get_node("World/EnemiesTeam")
	
	var BASE_POSITION := Vector2(300, 150)
	var offset := Vector2(0, 0)
	
	var warrior := load("res://entities/characters/warrior/info.tres")
	
	for i in range(4):
		
		var warrior_instance := AIEntity.new()
		warrior_instance.stats = warrior.duplicate(true)
		warrior_instance.scale = Vector2(3, 3)
		warrior_instance.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		enemy_node.add_child(warrior_instance)
		warrior_instance.global_position = BASE_POSITION + offset
		offset += Vector2(20, warrior_instance.sprite_frames.get_frame_texture(warrior_instance.animation, warrior_instance.frame).get_size().y+75)
