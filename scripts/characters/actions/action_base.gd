extends Node

class_name ActionBase

@warning_ignore("unused_signal")
signal request_state_change(state_name: String)
signal on_before_make_action
signal on_after_make_action

@export var action_name: String
@export var action_description: String = ""
var controlled_node: PlayableEntity = null

func make_action() -> bool:
	on_before_make_action.emit()
	var ok := _own_action()
	prints("Action maded: ", action_name)
	on_after_make_action.emit()
	controlled_node.on_play.emit()
	return ok

func _own_action() -> bool:
	controlled_node.was_played = true
	return true
