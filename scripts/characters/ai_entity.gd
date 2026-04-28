extends CombatEntity

class_name AIEntity

## Type of entity
enum EntityAIType {
	## Select actions randomly
	RANDOM,
	## Select only damage actions (Attack and Magic)
	AGGRESIVE,
	## Select only attack action
	AGGRESSIVE_ATTACK,
	## Select only magic action
	AGGRESIVE_MAGIC,
	## Prioritize support actions (magic)
	SUPPORTER,
	## Prioritize defensive actions (block and magic)
	TANK,
	## Prioritize healer actions (magic)
	HEALER
}

@export var priority = 0
@export var type: EntityAIType = EntityAIType.RANDOM
@export var target: Array[AIUtils.AITarget] = [AIUtils.AITarget.RANDOM]

func use_turn() -> void:
	
	await get_tree().create_timer(0.30).timeout
	
	if type == EntityAIType.RANDOM:
		attack_player()
		await self.animation_finished
	
	was_played = true
	self.team.combat.next_turn()

func attack_player() -> void:
	var enemies = self.team.enemies_team.get_alive_allies()
	#print(enemies)
	
	if target[0] == AIUtils.AITarget.RANDOM:
		attack(enemies[randi_range(0, enemies.size()-1)])
