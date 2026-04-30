extends ItemList

class_name ActionsContainerNode

func update_list(actions: Array[ActionBase]) -> void:
	
	self.clear()
	
	for action in actions:
		
		self.add_item(action.name)
	
	self.select(0)
