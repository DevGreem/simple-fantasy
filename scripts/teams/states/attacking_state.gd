extends StateBase

class_name AttackingState

var assigned_team: PlayerTeam:
	get:
		return controlled_node

var _selected_index: int = 0
@export var arrow_node: ArrowPointer
@export var entity_stats: EntityStatsNode
var _attack_animation: AnimatedSprite2D 
var _attack_audio: AudioStreamPlayer2D
var _is_acting := false

func start(args = []):
	_selected_index = 0;
	assigned_team.selected_enemy = null
	arrow_node.select_object(
		get_hovered(),
		ArrowPointer.PointingDirection.LEFT,
		ArrowPointer.Sides.RIGHT,
		Vector2(25, 0)
	)
	
	if not args.is_empty():
		
		if args.size() > 0:
			_attack_animation = args[0] as AnimatedSprite2D
		
		if args.size() > 1:
			_attack_audio = args[1] as AudioStreamPlayer2D
	arrow_node.show()

func end():
	_is_acting = false
	arrow_node.hide()
	entity_stats.unselect()

func get_hovered() -> AIEntity:
	
	var available := assigned_team.enemies_team.get_alive_allies()
	
	if available.is_empty():
		state_machine.change_state("Idle")
		return
	
	var hovering := available[_selected_index]
	
	return hovering

func process_selected():
	
	var hovering_character := get_hovered()
	
	entity_stats.select(hovering_character)
	
	arrow_node.change_object(
		hovering_character
	)

func on_input(event: InputEvent) -> void:
	
	if assigned_team.combat.ended or _is_acting:
		return
	
	#print("Detected character selection action...")
	var available := assigned_team.enemies_team.get_alive_allies()
	
	if available.is_empty():
		state_machine.change_state("Idle")
		return
	
	if event.is_action_pressed("up"):
		self._selected_index -= 1
	elif event.is_action_pressed("down"):
		self._selected_index += 1
	
	self._selected_index = wrapi(_selected_index, 0, available.size())
	
	process_selected()
	
	if event.is_action_pressed("unselect_action"):
		get_viewport().set_input_as_handled()
		state_machine.change_state("Selecting")
		assigned_team.select_character(assigned_team.selected_character)
		return
	
	if event.is_action_pressed("select_action"):
		get_viewport().set_input_as_handled()
		
		_is_acting = true
		var player := assigned_team.selected_character
		var character := available[_selected_index]
		
		assigned_team.selected_enemy = character
		player.attack(
			character
		)
		
		if _attack_audio:
			player.add_child(_attack_audio)
			_attack_audio.play()
			_attack_audio.finished.connect(
				func():
					player.remove_child(_attack_audio)
			)
		
		if _attack_animation:
			character.add_child(_attack_animation)
			_attack_animation.play()
			await _attack_animation.animation_finished
			character.remove_child(_attack_animation)
		
		if player.is_playing() and not player.sprite_frames.get_animation_loop(character.animation):
			await player.animation_finished
		else:
			await get_tree().create_timer(0.3).timeout
		
		state_machine.change_state("Idle")
		player.unselect()
		assigned_team.combat.end_turn(player)
