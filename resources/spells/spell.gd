extends Resource

class_name Spell

## Define who's can spell target
enum Target {
	RANDOM = 0,
	# Self team
	## Target self
	SELF = 16,
	## Target an ally
	ALLY = 17,
	## Target an ally or self
	ALLY_OR_SELF = 18,
	## Target all team allies
	ALLIES = 32,
	## Target a random ally
	RANDOM_ALLY = 21,
	## Target all enemies and an ally
	ENEMIES_ALLY = 64,
	# Enemies team
	## Target an enemy
	ENEMY = 65,
	## Target all allies and a enemy
	ALLIES_ENEMY = 67,
	## Target all team enemies
	ENEMIES = 128,
	## Target a random enemy
	RANDOM_ENEMY = 69,
	# Both teams
	## Target one enemy or ally
	BOTH = 130,
	## Target all teams members
	TEAMS = 256
}

## Defined who's can be selectable by the spell
enum Selectable {
	NONE,
	## Can only select he's proper team
	SELF_TEAM,
	## Can only select enemies team
	ENEMIES,
	## Can select all teams
	BOTH
}

signal finished

@export var name: String
@export var description := ""
@export var mana_cost := 0
@export var target := Target.ENEMY 
@export var accept_died := false
@export var self_apply := false
@export var effect: Array[SpellEffect] = []

func apply_effects(caster: CombatEntity = null, targets: Array[CombatEntity] = []) -> void:
	
	if self_apply:
		targets.append(caster)
	
	for targeted in targets:
		for eff in effect:
			eff.apply(caster, targeted)
	
	finished.emit()

func is_selectable() -> bool:
	
	return target not in [
		Target.SELF,
		Target.ALLIES,
		Target.ENEMIES,
		Target.TEAMS,
		Target.RANDOM,
		Target.RANDOM_ALLY,
		Target.RANDOM_ENEMY
	]

func can_select() -> Selectable:
	if target <= 64:
		return Selectable.SELF_TEAM
	elif target <= 128:
		return Selectable.ENEMIES
	else:
		return Selectable.BOTH

## Returns if the spell can be pointed to a entity
func can_point() -> bool:
	# Can point: SELF, ALLIES, ALLIES_SELF, ENEMIES, ENEMIES_SELF, TEAMS
	# All of this values have the next condition:
	# He's id is a power of two
	return not MathUtils.is_power_of_two(target)
