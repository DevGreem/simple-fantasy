extends Node

var ACTIONS: Array[GDScript] = [
	preload("res://scripts/characters/actions/attack_action.gd"),
	preload("res://scripts/characters/actions/block_action.gd"),
	preload("res://scripts/characters/actions/run_action.gd")
]

func start_combat(player_team: Array[EntityData]):
	
	var combat_scene: PackedScene = load("res://scenes/combat/combat.tscn")
	
	var instance := combat_scene.instantiate()
	
	_load_player_team(instance, player_team)
	
	prints("Loaded combat")
	
	get_tree().change_scene_to_node(instance)

func _generate_enemies() -> void:
	return

func _load_player_team(instance: Node, player_team: Array[EntityData]) -> void:
	
	var player_node: PlayerTeam = instance.get_node("World/PlayerTeam")
	var actions := _load_actions()
	
	var offset := Vector2(0, 0)
	
	for character in player_team:
		var entity := PlayableEntity.new()
		entity.add_child(actions.duplicate())
		entity.stats = character
		player_node.add_child(entity)
		entity.global_position -= offset
		offset += Vector2(0, 40)
	
func _load_actions() -> ActionsContainer:
	
	var container := ActionsContainer.new()
	
	for action in ACTIONS:
		container.add_child(
			action.new()
		)
	
	return container
