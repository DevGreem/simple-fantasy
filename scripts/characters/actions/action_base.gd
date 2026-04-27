extends Node

class_name ActionBase

@export var action_name: String
@export var action_description: String = ""
var controlled_node: PlayableEntity = null

func make_action() -> void:
	controlled_node.was_played = true
