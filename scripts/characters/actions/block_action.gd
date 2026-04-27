extends ActionBase

class_name BlockAction

func make_action() -> void:
	controlled_node.blocking = true
	super.make_action()
