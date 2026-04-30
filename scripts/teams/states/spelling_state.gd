extends StateBase

class_name SpellingState

var assigned_team: PlayerTeam:
	get:
		return controlled_node

@export var spells_container: EntitySpellsContainerNode

var hovered: PlayableEntity:
	get:
		return assigned_team.selected_character

var selected_spell: Spell:
	get:
		return hovered.stats.spells[_selected_index]

var _selected_index := 0:
	set(value):
		value = wrapi(value, 0, hovered.stats.spells.size())
		_selected_index = value

var _returned := false

func start(_args = []):
	self._returned = false
	self._selected_index = 0
	spells_container.update_data(hovered)

func end():
	
	if _returned:
		spells_container.unselect()
		spells_container.hide()

func on_input(event: InputEvent):
	
	if _returned:
		return
	
	if event.is_action_pressed("up"):
		self._selected_index -= 1
	elif event.is_action_pressed("down"):
		self._selected_index += 1
	
	if event.is_action_pressed("unselect_action"):
		_returned = true
		state_machine.change_state("Selecting")
		assigned_team.select_character(assigned_team.selected_character)
		return
	
	if event.is_action_pressed("select_action"):
		
		if selected_spell.mana_cost > assigned_team.selected_character.stats.mana:
			spells_container.unselect()
			return
		
		if selected_spell.target == Spell.Target.SELF:
			hovered.cast_spell(selected_spell, [hovered])
			await selected_spell.finished
			spells_container.select()
			spells_container.hide()
			state_machine.change_state("Idle")
		else:
			state_machine.change_state("TargetingSpell", [selected_spell])
