extends ItemList

class_name ActionsContainerNode

@export var arrow: ArrowPointer

func _ready():
	self.item_selected.connect(_on_select_item)

func update_list(actions: Array[ActionBase]) -> void:
	
	self.clear()
	
	for action in actions:
		
		self.add_item(action.action_name)
	
	self.select(0)

func _on_select_item(index: int):
	prints("Selecting item: ", index)
	arrow.point_rect(get_item_rect(get_selected_items()[0]), Vector2i(-1, 1))
