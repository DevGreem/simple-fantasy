extends Resource

class_name Spell

## Define who's can spell target
enum Target {
	# Self team
	## Target self
	SELF = 1,
	## Target an ally
	ALLY = 6,
	## Target an ally or self
	ALLY_OR_SELF = 2,
	## Target an ally and self,
	ALLY_AND_SELF = 3,
	## Target all team allies
	ALLIES = 2,
	## Target all team allies and self
	ALLIES_SELF = 5,
	## Target all enemies and an ally
	ENEMIES_ALLY = 4,
	# Enemies team
	## Target an enemy
	ENEMY = 7,
	## Target an enemy and self
	ENEMY_AND_SELF = 10,
	## Target all allies and a enemy
	ALLIES_ENEMY = 9,
	## Target all team enemies
	ENEMIES = 8,
	## Target all team enemies and self
	ENEMIES_SELF = 11,
	# Both teams
	## Target an enemy or self
	ENEMY_OR_SELF = 12,
	## Target one enemy or ally
	BOTH = 13,
	## Target an enemy or ally or self
	BOTH_OR_SELF = 14,
	## Target an enemy or ally and self
	BOTH_AND_SELF = 15,
	## Target all teams members
	TEAMS = 16
}

## Defined who's can be selectable by the spell
enum Selectable {
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
@export var effect: Array[SpellEffect] = []

func apply_effects(caster: CombatEntity = null, targets: Array[CombatEntity] = []) -> void:
	
	for targeted in targets:
		for eff in effect:
			eff.apply(caster, targeted)
	
	finished.emit()

func can_select() -> Selectable:
	if target <= 6:
		return Selectable.SELF_TEAM
	elif target <= 11:
		return Selectable.ENEMIES
	else:
		return Selectable.BOTH

## Returns if the spell can be pointed to a entity
func can_point() -> bool:
	# Can point: SELF, ALLIES, ALLIES_SELF, ENEMIES, ENEMIES_SELF, TEAMS
	# All of this values (except ENEMIES_SELF) have the next condition:
	# He's id is a power of two
	return not (MathUtils.is_power_of_two(target) or target == Target.ENEMIES_SELF)
