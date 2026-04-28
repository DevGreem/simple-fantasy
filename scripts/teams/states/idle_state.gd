extends StateBase

class_name IdleState

@onready var combat_node: CombatScene = owner
@export var arrow_node: ArrowPointer

func start():
	combat_node.changed_turn.connect(_on_change_turn)
	arrow_node.unpoint()
	call_deferred("_sync_turn")

func end():
	combat_node.changed_turn.disconnect(_on_change_turn)

func _sync_turn():
	_on_change_turn(combat_node.actual_turn)

func _on_change_turn(_num_turn: int):
	#prints("Controlled node: ", controlled_node)
	#prints("Actual team turn: ", combat_node.actual_team())
	
	if combat_node.ended:
		return
	
	if combat_node.actual_turn % 2 == 0:
		state_machine.change_state("SelectingCharacter")
