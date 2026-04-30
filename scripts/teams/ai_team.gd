extends CombatTeam

class_name AITeam

@export var order: Array[AIUtils.AITarget] = [AIUtils.AITarget.RANDOM]
var _picked_ally: AIEntity

func start_turn():
	_select_entity()

func _select_entity():
	
	var available := get_available_allies()
	
	if available.is_empty():
		_reset_played_characters()
		available = get_available_allies()
	
	if order[0] == AIUtils.AITarget.RANDOM:
		
		_picked_ally = available.pick_random()
		
		await _picked_ally.use_turn()
	
	if combat:
		combat.end_turn(_picked_ally)
