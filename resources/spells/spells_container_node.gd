extends ItemList

class_name SpellsContainerNode

func update_list(actions: Array[Spell]) -> void:
	
	self.clear()
	
	for action in actions:
		
		self.add_item(action.name)
	
	if get_item_at_position(Vector2(0, 0), true) != -1:
		self.select(0)
