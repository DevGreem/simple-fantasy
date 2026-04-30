extends AnimatedResource

class_name ActionBase

signal before_execute(action_name: String)
signal after_execute(action_name: String)
@warning_ignore("unused_signal")
signal request_state_change(state_name: String, args: Array)

@export var name: String
@export var description: String
@export var mana_cost: int = 0

func execute(actor: CombatEntity, target: CombatEntity):
	before_execute.emit(self.name)
	self._action(actor, target)
	after_execute.emit(self.name)

@warning_ignore("unused_parameter")
func _action(actor: CombatEntity = null, target: CombatEntity = null) -> void:
	pass
