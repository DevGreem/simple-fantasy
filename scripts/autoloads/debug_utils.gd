extends Node


func _input(event: InputEvent):
	
	if not OS.is_debug_build():
		return
	
	if event.is_action_pressed("load_map"):
		
		var team: Array[EntityData] = []
		
		var spawns: PlayerSpawn = load("res://entities/characters/playable_spawn.tres")
		for character in spawns.characters:
			team.append(character.scene.instantiate().stats)
		
		CombatInitializer.start_combat(team)
