extends RichTextLabel

class_name EntityStatsNode

var character: CombatEntity:
	set(value):
		character = value

func select(new_character: CombatEntity):
	self.character = new_character
	self.show()

func unselect() -> void:
	self.hide()

func _process(_delta):
	
	if not character:
		return
	
	var stats := character.stats
	
	self.text = """Name: %s
Health: %d/%d
Damage: %d - %d
Defense: %d - %d
Mana: %d/%d
Can play: %s
""" % [
	stats.name,
	stats.hp,
	stats.max_hp,
	stats.dmg.min_value,
	stats.dmg.max_value,
	stats.def.min_value,
	stats.def.max_value,
	stats.mana,
	stats.max_mana,
	not character.was_played or not character.was_played
]
	
