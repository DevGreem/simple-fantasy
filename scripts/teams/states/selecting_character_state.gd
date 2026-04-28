extends StateBase

class_name SelectingCharacterState

var assigned_team: PlayerTeam:
	get:
		return controlled_node

var _selected_index: int = 0

@export var arrow_node: ArrowPointer

func start():
	
	if assigned_team.combat.ended:
		set_process_input(false)
		state_machine.change_state("Idle")
	else:
		set_process_input(true)
	
	await get_tree().process_frame
	self._selected_index = 0
	assigned_team.select_character()
	
	process_selected()
	#prints("Started State ", self.name, " with team: ", self.assigned_team)

func end():
	arrow_node.unpoint()

func process_selected() -> void:
	var available := assigned_team.get_available_allies()
	
	if available.size() == 0:
		state_machine.change_state("Idle")
		return
	
	var hovering_character := available[_selected_index]
	
	arrow_node.point_to(
		hovering_character,
		ArrowPointer.PointingDirection.DOWN,
		Vector2(0, 20),
		Vector2i(1, 0)
	)

func on_input(event: InputEvent) -> void:
	#print("Detected character selection action...")
	var available := assigned_team.get_available_allies()
	
	if available.is_empty():
		state_machine.change_state("Idle")
		return
	
	if event.is_action_pressed("up"):
		self._selected_index -= 1
	elif event.is_action_pressed("down"):
		self._selected_index += 1
	
	self._selected_index = wrapi(_selected_index, 0, available.size())
	
	process_selected()
	
	if event.is_action_pressed("select_action"):
		assigned_team.select_character(available[_selected_index])
		state_machine.change_state("Selecting")
