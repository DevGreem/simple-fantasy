extends ActionBase

class_name RunAction

func _own_action() -> bool:
	
	var prob = controlled_node.run_percent
	
	if randf() <= prob:
		get_tree().change_scene_to_file("res://scenes/map.tscn")
		return true
	
	return super._own_action()
