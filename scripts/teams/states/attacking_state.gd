extends StateBase

class_name AttackingState

var assigned_team: PlayerTeam:
	get:
		return controlled_node

var _selected_index: int = 0
@export var arrow_node: ArrowPointer
var _is_acting := false

func start():
	_selected_index = 0;
	assigned_team.selected_enemy = null

func end():
	_is_acting = false
	arrow_node.unpoint()

func process_selected():
	
	var available := assigned_team.enemies_team.get_alive_allies()
	
	if available.is_empty():
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
	
	if assigned_team.combat.ended or _is_acting:
		return
	
	#print("Detected character selection action...")
	var available := assigned_team.enemies_team.get_alive_allies()
	
	if available.is_empty():
		state_machine.change_state("Idle")
		return
	
	if event.is_action_pressed("up"):
		self._selected_index -= 1
	
	if event.is_action_pressed("down"):
		self._selected_index += 1
	
	self._selected_index = wrapi(_selected_index, 0, available.size())
	
	process_selected()
	
	if event.is_action_pressed("select_action"):
		_is_acting = true
		assigned_team.selected_enemy = available[_selected_index]
		assigned_team.selected_character.attack(
			assigned_team.selected_enemy
		)
		
		await assigned_team.selected_character.animation_finished
		
		state_machine.change_state("Idle")
		assigned_team.selected_character.unselect()
		assigned_team.combat.next_turn()
