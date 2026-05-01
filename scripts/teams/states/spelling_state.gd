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
	hovered.play("spelling")

func end():
	
	if _returned:
		spells_container.can_input = false
	else:
		spells_container.hide()
	hovered.play("idle")

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
		
		_manage_spell_selection()
		#if not selected_spell.is_selectable():
			#pass
		#if selected_spell.target == Spell.Target.SELF:
			#hovered.cast_spell(selected_spell, [hovered])
			#await selected_spell.finished
			#spells_container.select()
			#spells_container.hide()
			#state_machine.change_state("Idle")
		#else:
			#state_machine.change_state("TargetingSpell", [selected_spell])

func _manage_spell_selection() -> void:
	
	if not selected_spell.is_selectable():
		
		match selected_spell.target:
			Spell.Target.SELF:
				_make_spell([hovered])
				state_machine.change_state("Idle")
			Spell.Target.RANDOM_ALLY:
				_is_empty_team(assigned_team)
			Spell.Target.ALLIES:
				_is_empty_array(_get_possible_allies())
			Spell.Target.ENEMIES:
				_make_spell(_get_possible(assigned_team.enemies_team))
			Spell.Target.RANDOM_ENEMY:
				_is_empty_team(assigned_team.enemies_team)
			Spell.Target.TEAMS:
				var arr = _get_possible(assigned_team)
				arr.append_array(_get_possible(assigned_team.enemies_team))
				_make_spell(arr)
		
		state_machine.change_state("Idle")
		assigned_team.combat.end_turn(hovered)
		return
	
	var selectable := selected_spell.can_select()
	
	if selected_spell.can_point():
		
		match selectable:
			Spell.Selectable.SELF_TEAM:
				state_machine.change_state("PointableTargetingSpell", [selected_spell, assigned_team])
			Spell.Selectable.ENEMIES:
				state_machine.change_state("PointableTargetingSpell", [selected_spell, assigned_team.enemies_team])
			Spell.Selectable.BOTH:
				pass
		
		return
	#else:
		#
		#match selectable:
			#Spell.Selectable.SELF_TEAM:
				#pass
			#Spell.Selectable.ENEMIES:
				#pass
			#Spell.Selectable.BOTH:
				#pass

func _get_possible(team: CombatTeam) -> Array[CombatEntity]:
	
	if selected_spell.accept_died:
		return team.allies
	else:
		return team.get_alive_allies()

func _get_possible_allies() -> Array[CombatEntity]:
	
	var result: Array[CombatEntity] = []
	
	if selected_spell.accept_died:
		result.assign(assigned_team.get_unselected_allies())
	else:
		result.assign(assigned_team.get_unselected_alive_allies())
	
	return result

func _make_spell(targets: Array[CombatEntity]) -> void:
	hovered.cast_spell(selected_spell, targets)
	await selected_spell.finished
	spells_container.unshow_data()

func _is_empty_team(team: CombatTeam) -> void:
	
	var available := _get_possible(team)
	
	if not available.is_empty():
		_make_spell(available)
	else:
		state_machine.change_state("Spelling")

func _is_empty_array(arr: Array[CombatEntity]):
	
	if not arr.is_empty():
		_make_spell(arr)
	else:
		state_machine.change_state("Spelling")
