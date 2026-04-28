extends HBoxContainer

class_name EntityInfoContainerNode

var selected_character: PlayableEntity
var actions: Array[ActionBase]:
	get:
		return selected_character.get_actions()
var _can_input := false

var index := 0:
	set(value):
		
		if not selected_character:
			return
		
		if value < 0 or value >= actions.size():
			return
		
		index = value
		actions_list.select(value)
		action_label.text = actions[value].action_description

@onready var actions_list: ActionsContainerNode = get_node("Actions")
@onready var action_label: Label = get_node("ActionDescription")

func _on_player_team_on_select_character(character: PlayableEntity) -> void:
	self.show()
	self.index = 0
	self.selected_character = character
	self.actions_list.update_list(actions)
	self.action_label.text = actions[0].action_description
	
	await get_tree().process_frame
	_can_input = true

func _on_player_team_on_unselect_character() -> void:
	_can_input = false
	self.hide()

func _input(event: InputEvent) -> void:
	
	if not selected_character or not _can_input:
		return
	
	if event.is_action_pressed("up"):
		self.index -= 1
	
	if event.is_action_pressed("down"):
		self.index += 1
	
	if event.is_action_pressed("select_action"):
		_can_input = false
		self.hide()
		
