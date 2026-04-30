extends ActionBase

class_name AttackAction

func _action(_actor: CombatEntity = null, _target: CombatEntity = null) -> void:
	request_state_change.emit("Attacking", [_load_animation(), _load_sound()])
