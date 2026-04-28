extends StateBase

class_name SelectingState

var assigned_team: PlayerTeam:
	get:
		return controlled_node

var _selected_action_index := 0:
	set(value):
		prints("New selected index: ", _selected_action_index)
		value = wrapi(value, 0, assigned_team.selected_character.get_actions().size())
		
		_selected_action_index = value
		#prints("New action index: ", _selected_action_index)

var _requested_state_change := false
var _is_acting := false

func start():
	self._selected_action_index = 0
	self._requested_state_change = false
	_is_acting = false

func end():
	self._selected_action_index = 0
	self._requested_state_change = false
	_is_acting = false

func on_input(event: InputEvent) -> void:
	
	if _is_acting:
		return
	
	if event.is_action_pressed("up"):
		self._selected_action_index -= 1
		return
		
	elif event.is_action_pressed("down"):
		self._selected_action_index += 1
		return
		
	elif event.is_action_pressed("unselect_action"):
		assigned_team.select_character()
		state_machine.change_state("SelectingCharacter")
		
	elif event.is_action_pressed("select_action"):
		var ally := self.assigned_team.selected_character
		var action: ActionBase = ally.get_actions()[_selected_action_index]
		
		if not action.request_state_change.is_connected(_on_request_state):
			action.request_state_change.connect(_on_request_state)
		
		action.make_action()
		prints("Maded action: ", action.action_name)
		
		action.request_state_change.disconnect(_on_request_state)
		
		if not self._requested_state_change:
			prints("Action not requests state change")
			_is_acting = true
			
			if ally.blocking:
				await get_tree().create_timer(0.3).timeout
			else:
				await ally.animation_finished
				
			assigned_team.select_character()
			
			state_machine.change_state("Idle")
			self.assigned_team.combat.next_turn()
		
func _on_request_state(state_name: String) -> void:
	self._requested_state_change = true
	state_machine.change_state(state_name)
