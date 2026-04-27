extends StateBase

class_name SelectingCharacterState

var assigned_team: PlayerTeam:
	get:
		return controlled_node
@export var arrow_node: ArrowPointer

func start():
	
	await get_tree().process_frame
	
	prints("Started State ", self.name, " with team: ", self.assigned_team)
	self.assigned_team.selected_character = 0
	move_arrow_to()

func on_input(event: InputEvent) -> void:
	print("Detected character selection action...")
	
	if event.is_action_pressed("up"):
		self.assigned_team.selected_character -= 1
	
	if event.is_action_pressed("down"):
		self.assigned_team.selected_character += 1
	
	move_arrow_to()
	
	if event.is_action_pressed("select_action"):
		state_machine.change_state("Selecting")
		self.assigned_team.is_character_selected = true

func move_arrow_to() -> void:
	var selected_ally = self.assigned_team.get_selected_ally()
	arrow_node.point_to(selected_ally, Vector2i(0, 0))
