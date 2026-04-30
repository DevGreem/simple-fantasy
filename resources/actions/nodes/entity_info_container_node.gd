extends HBoxContainer

class_name EntityInfoContainerNode

var _can_input := false
@export var player_team: PlayerTeam:
	set(value):
		player_team = value
		_init_team_signals()
var actions: Array[ActionBase]:
	get:
		return player_team.selected_character.stats.actions

var index := 0:
	set(value):
		
		if not player_team.selected_character:
			return
		
		value = wrapi(value, 0, actions.size())
		
		index = value
		actions_list.select(value)
		action_label.text = actions[value].description

@onready var actions_list: ActionsContainerNode = $Actions
@onready var action_label: Label = $ActionDescription

func _ready() -> void:
	
	if player_team:
		_init_team_signals()

func _init_team_signals() -> void:
	if not player_team.on_select_character.is_connected(_on_player_team_on_select_character):
		player_team.on_select_character.connect(_on_player_team_on_select_character)
	
	if not player_team.on_unselect_character.is_connected(_on_player_team_on_unselect_character):
		player_team.on_unselect_character.connect(_on_player_team_on_unselect_character)

func _on_player_team_on_select_character() -> void:
	self.show()
	self.actions_list.update_list(actions)
	self.action_label.text = actions[0].description
	self.index = 0
	
	await get_tree().process_frame
	_can_input = true

func _on_player_team_on_unselect_character() -> void:
	_can_input = false
	self.hide()

func _input(event: InputEvent) -> void:
	
	if not player_team or not player_team.selected_character or not _can_input:
		return
	
	if event.is_action_pressed("up"):
		self.index -= 1
	
	elif event.is_action_pressed("down"):
		self.index += 1
	
	if event.is_action_pressed("select_action"):
		_can_input = false
		
