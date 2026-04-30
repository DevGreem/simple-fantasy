extends ActionBase

class_name BlockAction

func _action(actor: CombatEntity = null, _target: CombatEntity = null) -> void:	
	actor.block()
