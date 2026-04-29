extends Node2D

class_name CombatInitializer

static func start_combat(player_team: Array[EntityData]):
	
	var combat_scene: PackedScene = load("res://scenes/combat.tscn")
	
	var instance := combat_scene.instantiate()
	
	_load_player_team(instance, player_team)

static func _generate_enemies() -> void:
	return

static func _load_player_team(instance: Node, player_team: Array[EntityData]) -> void:
	
	var player_node: PlayerTeam = instance.get_node("/root/Combat/World/PlayerTeam")
	
	for character in player_team:
		var entity := PlayableEntity.new()
		entity.stats = character
		player_node.add_child(entity)
	
	
