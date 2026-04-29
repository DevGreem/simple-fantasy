extends StateBase

class_name SelectingCharacterState

var assigned_team: PlayerTeam:
	get:
		return controlled_node

var _selected_index: int = 0

@export var arrow_node: ArrowPointer
@export var show_stats_node: EntityStatsNode

func start(..._args):
	
	if assigned_team.combat.ended:
		set_process_input(false)
		state_machine.change_state("Idle")
	else:
		set_process_input(true)
	
	await get_tree().process_frame
	self._selected_index = wrapi(_selected_index, 0, get_total_availables())
	assigned_team.select_character()
	show_stats_node.show()
	arrow_node.select_object(
		get_hovered(),
		ArrowPointer.PointingDirection.RIGHT,
		ArrowPointer.Sides.LEFT,
		Vector2(-25, 0)
	)
	arrow_node.show()
	
	process_selected()
	#prints("Started State ", self.name, " with team: ", self.assigned_team)

func end():
	arrow_node.hide()
	show_stats_node.hide()

func get_total_availables() -> int:
	
	var available := assigned_team.allies
	
	return available.size()

func get_hovered() -> PlayableEntity:
	var available := assigned_team.allies
	
	if available.is_empty():
		state_machine.change_state("Idle")
		return
	
	return available[_selected_index]

func process_selected() -> void:
	
	var hovered := get_hovered()
	
	if hovered.was_played:
		arrow_node.modulate = Color(255, 0, 0)
	else:
		arrow_node.modulate = arrow_node.self_modulate
	
	arrow_node.change_object(hovered)

func on_input(event: InputEvent) -> void:
	#print("Detected character selection action...")
	
	
	if event.is_action_pressed("up"):
		self._selected_index -= 1
	elif event.is_action_pressed("down"):
		self._selected_index += 1
	
	self._selected_index = wrapi(_selected_index, 0, get_total_availables())
	
	process_selected()
	
	var hovered := get_hovered()
	
	show_stats_node.character = hovered
	
	if event.is_action_pressed("select_action"):
		
		if not hovered.is_alive() or hovered.was_played:
			return
		
		assigned_team.select_character(hovered)
		state_machine.change_state("Selecting")
