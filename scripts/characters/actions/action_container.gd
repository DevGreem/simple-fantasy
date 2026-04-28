extends Node

class_name ActionsContainer

var actions: Array[ActionBase]:
	get:
		return get_actions()

func _ready():
	_start_actions()

func _start_actions():
	
	for action: ActionBase in self.actions:
		
		action.controlled_node = self.get_parent()

func get_actions() -> Array[ActionBase]:
	
	var actions_arr: Array[ActionBase] = []
	
	for action: ActionBase in self.get_children(true):
		#prints("Actual action initializing: ", action.action_name)
		
		if action is ActionBase:
			
			#prints("Actual action: ", action)
			
			actions_arr.append(action)
	
	return actions_arr
