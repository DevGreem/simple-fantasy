extends ActionBase

class_name AttackAction

func make_action() -> void:
	print("Attacking!")
	controlled_node.attack()
	super.make_action()
	
