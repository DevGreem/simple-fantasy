extends Node

class_name StateBase

var state_machine: StateMachine
var controlled_node: Node

func start() -> void:
	pass

func end() -> void:
	pass

func on_process(_delta: float) -> void:
	pass

func on_input(_event: InputEvent) -> void:
	pass

func on_unhandled_input(_event: InputEvent) -> void:
	pass

func on_unhandled_key_input(_event: InputEvent) -> void:
	pass
