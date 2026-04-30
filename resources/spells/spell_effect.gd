@abstract
extends AnimatedResource

class_name SpellEffect

@export var power := IntRange.new()

@abstract
func apply(caster: CombatEntity = null, targets: CombatEntity = null) -> void
