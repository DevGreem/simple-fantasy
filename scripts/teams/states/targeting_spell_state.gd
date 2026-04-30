extends StateBase

class_name TargetingSpellState

var player_team: PlayerTeam:
	get:
		return controlled_node

var enemy_team: AITeam:
	get:
		return player_team.enemies_team

var targeted_team: CombatTeam:
	set(value):
		targeted_team = value
		_selected_index = _selected_index
		
		arrow_node.select_object(
			targeted_team.get_ally(_selected_index),
			ArrowPointer.PointingDirection.LEFT,
			ArrowPointer.Sides.RIGHT,
			arrow_node.offset
		)

var current_character: PlayableEntity:
	get:
		return player_team.selected_character

var current_spell: Spell:
	set(value):
		current_spell = value
		selectable = current_spell.can_select()
		pointable = current_spell.can_point()

var selectable: Spell.Selectable
var pointable: bool

var _selected_index: int = 0:
	set(value):
		_selected_index = wrapi(value, 0, targeted_team.allies.size())

@export var arrow_node: ArrowPointer
@export var spells_container: EntitySpellsContainerNode

var _can_input := true

func start(args = []):
	
	if args[0]:
		current_spell = args[0] as Spell
	
	if selectable == Spell.Selectable.SELF_TEAM:
		targeted_team = player_team
		self._selected_index = 0
		arrow_node.show()
	elif selectable == Spell.Selectable.ENEMIES:
		targeted_team = enemy_team
		self._selected_index = 0
		arrow_node.show()
	
	_can_input = true

func end():
	spells_container.unshow_data()
	arrow_node.hide()

func on_input(event: InputEvent):
	
	if not _can_input:
		return
	
	if selectable == Spell.Selectable.BOTH:
		
		if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_right"):
			self.change_team()
	elif selectable == Spell.Selectable.SELF_TEAM:
		targeted_team = player_team
	else:
		targeted_team = enemy_team
	
	if pointable:
		if event.is_action_pressed("up"):
			self._selected_index -= 1
		elif event.is_action_pressed("down"):
			self._selected_index += 1
	
	if event.is_action_pressed("unselect_action"):
		state_machine.change_state("Spelling")
	elif event.is_action_pressed("select_action"):
		
		current_spell.finished.connect(_on_finish_spell)
		
		if pointable:
			current_character.cast_spell(
				current_spell,
				[targeted_team.get_ally(_selected_index)]
			)
		else:
			current_character.cast_spell(current_spell, targeted_team.allies)
		

func _on_finish_spell():
	current_spell.finished.disconnect(_on_finish_spell)
	state_machine.change_state("Idle")
	self.player_team.combat.end_turn(current_character)

func change_team():
	
	if targeted_team == player_team:
		targeted_team = enemy_team
	else:
		targeted_team = player_team
