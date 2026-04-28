extends CombatTeam

class_name AITeam

@export var order: Array[AIUtils.AITarget] = [AIUtils.AITarget.RANDOM]


func _on_set_combat():
	if combat and combat.changed_turn.is_connected(_on_change_turn):
			combat.changed_turn.disconnect(_on_change_turn)

func _on_combat_ready():
	
	combat.changed_turn.connect(_on_change_turn)
	_on_change_turn(combat.actual_turn)

func _on_change_turn(new_turn: int):
	
	if combat.ended:
		return
	
	if new_turn % 2 == 1:
		_select_entity()

func _select_entity():
	
	if order[0] == AIUtils.AITarget.RANDOM:
		
		var picked_ally: AIEntity = self.get_available_allies().pick_random()
		
		picked_ally.use_turn()
		return
