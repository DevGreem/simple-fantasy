extends HBoxContainer

class_name EntitySpellsContainerNode

var can_input := false

var character: PlayableEntity

var spells: Array[Spell]:
	get:
		return character.stats.spells

var index := 0:
	set(value):
		
		if not character:
			return
		
		value = wrapi(value, 0, spells.size())
		
		index = value
		
		if not spells.is_empty():
			spells_list.select(value)
			spell_label.text = spells[value].description

@onready var spells_list: SpellsContainerNode = $Spells
@onready var spell_label: Label = $SpellDescription

func update_data(entity: PlayableEntity) -> void:
	self.character = entity
	self.show()
	self.spells_list.update_list(spells)
	
	if not spells.is_empty():
		self.spell_label.text = spells[0].description
	else:
		self.spell_label.text = "You don't have spells"
	self.index = 0
	
	await get_tree().process_frame
	can_input = true

func unshow_data() -> void:
	can_input = false
	self.hide()

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("unselect_action"):
		unshow_data()
	
	if not character or not can_input:
		return
	
	if event.is_action_pressed("up"):
		self.index -= 1
	
	elif event.is_action_pressed("down"):
		self.index += 1
	
	if event.is_action_pressed("select_action"):
		can_input = true
