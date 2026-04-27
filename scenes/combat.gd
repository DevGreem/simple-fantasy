extends Node2D

class_name CombatScene

signal changed_turn(new_turn: int)

@export var left_team: CombatTeam
@export var right_team: CombatTeam

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
	
	self._connect_changed_turns(left_team.allies)
	self._connect_changed_turns(right_team.allies)
	left_team.combat = self
	right_team.combat = self

func _process(_delta: float):
	var both_sizes = [self.left_team.allies.size(), self.right_team.allies.size()]
	if both_sizes[0] == 0 or both_sizes[1] == 0:
		get_tree().change_scene_to_file("res://scenes/map.tscn")
		
		if both_sizes[1] > 0:
			print("You win!")
		else:
			print("You lose...")
		return

func next_turn() -> void:
	_turn += 1

func get_other_team(team: CombatTeam) -> CombatTeam:
	
	prints("Incoming: ", team)
	prints("Left Team: ", left_team)
	prints("Right Team: ", right_team)
	
	if team == left_team:
		print("Is equal to left")
		return right_team
	
	if team == right_team:
		print("Is equal to right")
		return left_team
	
	print("Is equal to nothing")
	return null

func actual_team() -> CombatTeam:
	if actual_turn % 2 == 0:
		return right_team
	
	return left_team

func _connect_changed_turns(entities: Array[CombatEntity]):
	
	for entity in entities:
		self.changed_turn.connect(entity._on_change_turn)
