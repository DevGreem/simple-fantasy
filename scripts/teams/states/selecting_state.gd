extends StateBase

class_name SelectingState

var assigned_team: PlayerTeam:
	get:
		return controlled_node

var _selected_action_index := 0:
	set(value):
		
		if value < 0 or value >= len(self.assigned_team.get_selected_ally().get_actions()):
			return
		
		_selected_action_index = value
		prints("New action index: ", _selected_action_index)

@onready var combat_node: CombatScene = get_node("/root/Combat")

func on_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("up"):
		self._selected_action_index += 1
		return
	
	if event.is_action_pressed("down"):
		self._selected_action_index -= 1
		return
	
	if event.is_action_pressed("unselect_action"):
		state_machine.change_state("SelectingCharacter")
		self.assigned_team.is_character_selected = false
	
	if event.is_action_pressed("select_action"):
		state_machine.change_state("Idle")
		self.assigned_team.is_character_selected = false
		combat_node.next_turn()
		
	#if Input.is_action_just_pressed("select_action"):
		#var selected_action = self.assigned_team.get_selected_ally().get_actions()[_selected_action_index]
		#prints("Selected action: ", selected_action.action_name)
		#selected_action.make_action()
