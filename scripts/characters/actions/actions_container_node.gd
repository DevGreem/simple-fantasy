extends ItemList

class_name ActionsContainerNode

@export var arrow: ArrowPointer

func update_list(actions: Array[ActionBase]) -> void:
	
	self.clear()
	
	for action in actions:
		
		self.add_item(action.action_name)
	
	self.select(0)
