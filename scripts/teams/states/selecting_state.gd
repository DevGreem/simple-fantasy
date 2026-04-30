extends StateBase

class_name SelectingState

var assigned_team: PlayerTeam:
	get:
		return controlled_node
@export var info_container: EntityInfoContainerNode

var _selected_action_index := 0:
	set(value):
		#prints("New selected index: ", _selected_action_index)
		value = wrapi(value, 0, assigned_team.selected_character.stats.actions.size())
		
		_selected_action_index = value
		#prints("New action index: ", _selected_action_index)

var _requested_state_change := false
var _is_acting := false

func start(_args = []):
	self._selected_action_index = 0
	self._requested_state_change = false
	_is_acting = false
	info_container.show()

func end():
	self._selected_action_index = 0
	_is_acting = false
	info_container.hide()

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
		assigned_team.selected_character.was_played = false
		state_machine.change_state("SelectingCharacter")
		
	elif event.is_action_pressed("select_action"):
		var ally := self.assigned_team.selected_character
		var action: ActionBase = ally.stats.actions[_selected_action_index]
		
		if not action.request_state_change.is_connected(_on_request_state):
			action.request_state_change.connect(_on_request_state)
		
		action.execute(ally, null)
		#prints("Maded action: ", action.action_name)
		
		action.request_state_change.disconnect(_on_request_state)
		
		if not self._requested_state_change:
			#prints("Action not requests state change")
			_is_acting = true
			
			var is_looping = ally.sprite_frames.get_animation_loop(ally.animation)
			
			if ally.blocking or is_looping:
				var tree := get_tree()
				
				if tree:
					await tree.create_timer(0.15).timeout
			elif action.name != "Run":
				await ally.animation_finished
			
			assigned_team.select_character()
			
			state_machine.change_state("Idle")
			self.assigned_team.combat.end_turn(ally)
		
func _on_request_state(state_name: String, args: Array = []) -> void:
	self._requested_state_change = true
	state_machine.change_state(state_name, args)
