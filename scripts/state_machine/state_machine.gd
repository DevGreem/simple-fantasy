extends Node

class_name StateMachine

@onready var controlled_node = self.get_parent()

@export var default_state: StateBase
var actual_state: StateBase = null

func _ready():
	call_deferred("_state_default_start")

func _state_default_start() -> void:
	
	if not default_state:
		return
	
	actual_state = default_state
	_state_start()

func _state_start() -> void:
	
	actual_state.controlled_node = controlled_node
	actual_state.state_machine = self
	actual_state.start()
	
	#prints("StateMachine", controlled_node.name, "start state", actual_state.name)

func change_state(node: String) -> void:
	
	actual_state.end()
	
	actual_state = get_node(node)
	
	_state_start()
	
func _process(delta: float) -> void:
	
	
	if actual_state:
		actual_state.on_process(delta)

func _input(event: InputEvent) -> void:
	if actual_state:
		actual_state.on_input(event)

func _unhandled_input(event: InputEvent) -> void:
	if actual_state:
		actual_state.on_unhandled_input(event)

func _unhandled_key_input(event: InputEvent) -> void:
	if actual_state:
		actual_state.on_unhandled_key_input(event)
