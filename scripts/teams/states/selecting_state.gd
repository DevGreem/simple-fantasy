extends StateBase

class_name SelectingState

var assigned_team: PlayerTeam:
	get:
		return controlled_node

var _selected_action_index := 0:
	set(value):
		prints("New selected index: ", _selected_action_index)
		if value < 0 or value >= self.assigned_team.get_selected_ally().get_actions().size():
			return
		
		_selected_action_index = value
		#prints("New action index: ", _selected_action_index)

var _requested_state_change := false
var _is_acting := false

func start():
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
	
	if event.is_action_pressed("down"):
		self._selected_action_index += 1
		return
	
	if event.is_action_pressed("unselect_action"):
		self.assigned_team.is_character_selected = false
		state_machine.change_state("SelectingCharacter")
	
	if event.is_action_pressed("select_action"):
		var ally := self.assigned_team.get_selected_ally()
		var action: ActionBase = ally.get_actions()[_selected_action_index]
		
		if not action.request_state_change.is_connected(_on_request_state):
			action.request_state_change.connect(_on_request_state)
		
		action.make_action()
		
		action.request_state_change.disconnect(_on_request_state)
		
		self.assigned_team.is_character_selected = false
		ally.unselect()
		
		if not self._requested_state_change:
			_is_acting = true
			
			if ally.animation != "blocking":
				await ally.animation_finished
			
			state_machine.change_state("Idle")
			self.assigned_team.combat.next_turn()
		
func _on_request_state(state_name: String) -> void:
	self._requested_state_change = true
	state_machine.change_state(state_name)
