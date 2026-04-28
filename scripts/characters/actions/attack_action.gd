extends ActionBase

class_name AttackAction

func _own_action() -> bool:
	#print("Attacking!")
	request_state_change.emit("Attacking")
	return super._own_action()
	
