extends Node


func _input(event: InputEvent):
	
	if not OS.is_debug_build():
		return
	
	if event.is_action_pressed("load_map"):
		
		var team: Array[EntityData] = []
		
		for i in range(4):
			var resource := load("res://characters/warrior/warrior.tres")
			team.append(resource.duplicate())
		
		CombatInitializer.start_combat(team)
