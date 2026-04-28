extends ActionBase

class_name BlockAction

func _own_action() -> bool:
	controlled_node.block()
	return super._own_action()
