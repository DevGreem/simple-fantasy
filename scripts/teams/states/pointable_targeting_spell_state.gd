extends StateBase

class_name PointableTargetingSpellState

var player_team: PlayerTeam:
	get:
		return controlled_node

var targeted_team: CombatTeam
@export var arrow_node: ArrowPointer
@export var entity_stats: EntityStatsNode

var spell: Spell
var _selected_index := 0:
	set(value):
		
		if targeted_team:
			_selected_index = wrapi(value, 0, _verify_remove_self().size())
			return
		
		_selected_index = value
var _can_input := false

func start(args = []):
	self.spell = args[0] as Spell
	select_team(args[1] as CombatTeam)
	arrow_node.show()
	_can_input = true

func end():
	arrow_node.hide()
	entity_stats.unselect()
	_can_input = false

func on_input(event: InputEvent) -> void:
	
	if not _can_input:
		return
	
	if event.is_action_pressed("up"):
		self._selected_index -= 1
	elif event.is_action_pressed("down"):
		self._selected_index += 1
	
	var hovered := get_hovered()
	
	arrow_node.change_object(hovered)
	entity_stats.select(hovered)
	
	if event.is_action_pressed("unselect_action"):
		state_machine.change_state("Spelling")
	elif event.is_action_pressed("select_action"):
		_can_input = false
		player_team.selected_character.cast_spell(spell, [hovered])
		state_machine.change_state("Idle")
		player_team.combat.end_turn(player_team.selected_character)

func _verify_remove_self() -> Array[CombatEntity]:
	
	var team := _get_all_possible()
	
	if targeted_team != player_team:
		return team
	
	if spell.target != Spell.Target.ALLY_OR_SELF:
		return team.filter(
			func(entity: CombatEntity): return entity != player_team.selected_character
		)
	
	return team

func _get_all_possible() -> Array[CombatEntity]:
	
	if self.spell.accept_died:
		return targeted_team.allies
	else:
		return targeted_team.get_alive_allies()

func get_hovered() -> CombatEntity:
	return _verify_remove_self()[_selected_index]

func select_team(team: CombatTeam,) -> void:
	self.targeted_team = team
	self._selected_index = 0
	
	if targeted_team != player_team:
		arrow_node.select_object(
			get_hovered(),
			ArrowPointer.PointingDirection.LEFT,
			ArrowPointer.Sides.RIGHT,
			Vector2(25, 0)
		)
	else:
		arrow_node.select_object(
			get_hovered(),
			ArrowPointer.PointingDirection.RIGHT,
			ArrowPointer.Sides.LEFT,
			Vector2(-25, 0)
		)
