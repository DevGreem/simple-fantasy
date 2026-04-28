extends StateBase

class_name IdleState

var assigned_team: CombatTeam:
	get:
		return controlled_node
@export var arrow_node: ArrowPointer

func start():
	assigned_team.combat.changed_turn.connect(_on_change_turn)
	arrow_node.unpoint()
	call_deferred("_sync_turn")

func end():
	assigned_team.combat.changed_turn.disconnect(_on_change_turn)

func _sync_turn():
	_on_change_turn(assigned_team.combat.actual_turn)

func _on_change_turn(num_turn: int):
	#prints("Controlled node: ", controlled_node)
	#prints("Actual team turn: ", combat_node.actual_team())
	
	if assigned_team.combat.ended:
		return
	
	if num_turn % 2 == 0:
		state_machine.change_state("SelectingCharacter")
