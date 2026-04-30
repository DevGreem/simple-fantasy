extends SpellEffect

class_name FireballEffect

func apply(_caster: CombatEntity = null, target: CombatEntity = null) -> void:
	_make_effect_in(target)
	
	target.receive_damage(power.gen_num())
