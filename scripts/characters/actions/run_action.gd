extends ActionBase

class_name RunAction

func make_action():
	
	var prob = controlled_node.run_percent
	
	if randf() <= prob:
		get_tree().change_scene_to_file("res://scenes/map.tscn")
		return
	
	super.make_action()
