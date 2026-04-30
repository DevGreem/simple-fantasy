extends Node2D

class_name CombatScene

enum CombatPhase {
	STARTING,
	PLAYER_TURN,
	ENEMY_TURN,
	FINAL
}

signal changed_round(new_round: int)

@export var left_team: CombatTeam:
	set(value):
		
		left_team = value
		left_team.combat = self
		_rotate_left_team()
		
@export var right_team: CombatTeam:
	set(value):
		
		right_team = value
		right_team.combat = self

var phase := CombatPhase.STARTING

@export var audio_manager: AudioStreamPlayer2D
var ended := false
var _winner_team: CombatTeam

var current_round := 1:
	set(value):
		
		if value < 0:
			return
		
		current_round = value
		changed_round.emit(round)


func _ready():
	set_process_input(false)
	audio_manager.play()
	audio_manager.finished.connect(_exit_battle)
	_rotate_left_team()
	
	await get_tree().process_frame
	
	phase = CombatPhase.PLAYER_TURN
	_start_player_turn()

func _rotate_left_team() -> void:
	
	for character in left_team.allies:
		character.flip_h = true

func get_player_team() -> PlayerTeam:
	
	if left_team is PlayerTeam:
		return left_team
	
	return right_team

func get_ai_team() -> AITeam:
	
	if left_team is AITeam:
		return left_team
	
	return right_team

func _start_player_turn():
	_start_turn(get_player_team())

func _start_turn(team: CombatTeam):
	
	prints("Started team turn: ", team)
	if not _verify_win() or ended:
		return
	
	team.start_turn()

func end_turn(entity: CombatEntity):
	
	if ended:
		return
	
	if not _verify_win():
		return
	
	entity.was_played = true
	
	if not entity.sprite_frames.get_frame_texture(entity.animation, entity.frame):
		await entity.animation_finished
	else:
		
		var tree := get_tree()
		
		if tree:
			await get_tree().create_timer(0.3).timeout
	
	print("Ended turn")
	if phase == CombatPhase.PLAYER_TURN:
		_start_turn(get_ai_team())
		phase = CombatPhase.ENEMY_TURN
	
	elif phase == CombatPhase.ENEMY_TURN:
		_start_turn(get_player_team())
		phase = CombatPhase.PLAYER_TURN
		current_round += 1

#func next_turn() -> void:
	#var status := _verify_win()
	#
	#if status and not ended:
		#round += 1
		#prints("New turn: ", round)

func _end() -> void:
	
	if ended:
		return
	
	ended = true
	
	if _winner_team is PlayerTeam:
		var victory := load("res://audio/victory.mp3")
		audio_manager.stream = victory
		audio_manager.play()
		for character in _winner_team.allies:
			character.play("victory")
	else:
		var defeat := load("res://audio/defeat.mp3")
		audio_manager.stream = defeat
		audio_manager.play()
	
	phase = CombatPhase.FINAL
		
	set_process_input(true)

func _exit_battle() -> void:
	
	ended = true
	
	get_tree().change_scene_to_file("res://scenes/map.tscn")

func _input(event: InputEvent):
	
	if ended:
		return
	
	if event.is_action_pressed("select_action"):
		_exit_battle()

func manual_end(team: CombatTeam) -> void:
	#print("Invoked manual end")
	
	_winner_team = get_other_team(team)
	self._end()

func escape() -> void:
	await get_tree().process_frame
	_exit_battle()

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
