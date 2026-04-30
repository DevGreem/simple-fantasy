extends SpellEffect

class_name GodHealingEffect

func apply(_caster: CombatEntity = null, target: CombatEntity = null) -> void:
	_make_effect_in(target)
	target.receive_heal(power.gen_num())
