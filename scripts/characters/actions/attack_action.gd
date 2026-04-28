extends ActionBase

class_name AttackAction

func _own_action() -> bool:
	#print("Attacking!")
	controlled_node.attack()
	return super._own_action()
	
