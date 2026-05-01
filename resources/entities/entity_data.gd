extends Resource

class_name EntityData

signal on_die
signal on_revive

@export_category("Identification")
@export var name: String
@export var map_sprite: SpriteFrames
@export var combat_sprite: SpriteFrames
@export var actions: Array[ActionBase] = []
@export var spells: Array[Spell] = []

@export_category("Health")
@export var max_hp := 1:
	set(value):
		
		if value <= 0:
			value = 1
		
		max_hp = value
		
		if max_hp < hp:
			hp = max_hp

@export var hp := 1:
	set(value):
		
		if hp == 0 and value > 0:
			on_revive.emit()
		elif value <= 0:
			value = 0
			on_die.emit()
			#print_rich('**Character ', self, ' Died**')
		elif value > max_hp:
			value = max_hp
			
		hp = value
			

@export_category("Stats")
@export var dmg: IntRange
@export var def: IntRange

@export_category("Mana")
@export var max_mana := 1:
	set(value):
		
		if value < 0:
			value = 0
		
		max_mana = value
		
		if max_mana < mana:
			mana = max_mana

@export var mana := 1:
	set(value):
		mana = clamp(value, 0, max_mana)
