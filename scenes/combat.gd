@tool
extends Node2D

class_name CombatScene

signal changed_turn(new_turn: int)

@export var left_team: CombatTeam
@export var right_team: CombatTeam
@onready var audio_manager: AudioStreamPlayer2D = $Audio
var ended := false
var _winner_team: CombatTeam

var _turn := 0:
	set(value):
		
		if value < 0:
			return
		
		_turn = value
		changed_turn.emit(value)

var actual_turn: int:
	get:
		return _turn

func _ready():
	
	set_process_input(false)
	self._connect_changed_turns(left_team.allies)
	self._connect_changed_turns(right_team.allies)
	
	left_team.play_turns = 1
	right_team.play_turns = 0
	
	left_team.combat = self
	right_team.combat = self
	
	audio_manager.finished.connect(_exit_battle)
	rotate_left_team()

func rotate_left_team() -> void:
	
	for character in left_team.allies:
		character.flip_h = true

func next_turn() -> void:
	var status := _verify_win()
	
	if status and not ended:
		print("Passed turn")
		_turn += 1

func _end() -> void:
	
	if ended:
		return
	
	ended = true
	
	if _winner_team is PlayerTeam:
		audio_manager.play()
		for character in _winner_team.allies:
			character.play("victory")
	else:
		var defeat := load("res://audio/defeat.mp3")
		audio_manager.stream = defeat
		audio_manager.play()
		
	set_process_input(true)

func _exit_battle() -> void:
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _input(event: InputEvent):
	
	if event.is_action_pressed("select_action"):
		_exit_battle()

func manual_end(team: CombatTeam) -> void:
	print("Invoked manual end")
	
	_winner_team = get_other_team(team)
	self._end()

## Return [true] if the combat continues
func _verify_win() -> bool:
	var both_sizes = [self.left_team.get_alive_allies(), self.right_team.get_alive_allies()]
	
	if both_sizes[0].size() == 0 or both_sizes[1].size() == 0:
		_winner_team = left_team if both_sizes[0].size() > 0 else right_team
		self._end()
		return false
	
	return true

func get_other_team(team: CombatTeam) -> CombatTeam:
	
	#prints("Incoming: ", team)
	#prints("Left Team: ", left_team)
	#prints("Right Team: ", right_team)
	
	if team == left_team:
		#print("Is equal to left")
		return right_team
	
	if team == right_team:
		#print("Is equal to right")
		return left_team
	
	#print("Is equal to nothing")
	return null

func actual_team() -> CombatTeam:
	
	if actual_turn % 2 == left_team.play_turns:
		return left_team
	
	return right_team

func _connect_changed_turns(entities: Array[CombatEntity]):
	
	for entity in entities:
		self.changed_turn.connect(entity._on_change_turn)
