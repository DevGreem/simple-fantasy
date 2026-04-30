extends ActionBase

class_name CastSpellAction

func _action(_actor: CombatEntity = null, _target: CombatEntity = null) -> void:
	request_state_change.emit("Spelling")
