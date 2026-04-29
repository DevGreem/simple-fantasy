extends ActionBase

class_name RunAction

var player: PlayableEntity:
	get:
		return controlled_node

func _own_action() -> bool:
	
	var prob = player.run_percent
	
	if randf() <= prob:
		player.team.combat.escape()
		print("Escaped")
		return false
	
	print("No escaped")
	return super._own_action()
