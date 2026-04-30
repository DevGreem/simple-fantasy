extends ActionBase

class_name RunAction

func _action(actor: CombatEntity = null, _target: CombatEntity = null) -> void:
	var prob = actor.run_percent
	
	if randf() <= prob:
		actor.team.combat.escape()
		print("Escaped")
		return
	
	print("No escaped")
