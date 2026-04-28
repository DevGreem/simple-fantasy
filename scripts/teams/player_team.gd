extends CombatTeam

class_name PlayerTeam

signal on_change_character(index: int)
signal on_change_enemy(index: int)
signal on_select_character
signal on_unselect_character
signal on_select_enemy
signal on_unselect_enemy

var selected_character: PlayableEntity:
	set(value):
		selected_character = value
		on_change_character.emit(value)

var has_character_selected := false

func select_character(character: PlayableEntity = null):
	
	if character:
		selected_character = character
		selected_character.select()
		has_character_selected = true
		on_select_character.emit()
		return
	
	has_character_selected = false
	
	if selected_character:
		selected_character.unselect()
		on_unselect_character.emit()

var selected_enemy: AIEntity:
	set(value):
		selected_enemy = value
		on_change_enemy.emit(value)

var has_enemy_selected := false

func select_enemy(enemy: AIEntity = null):
	
	if enemy:
		selected_enemy = enemy
		has_enemy_selected = true
		on_select_enemy.emit()
		return
	
	has_enemy_selected = false
	
	if selected_enemy:
		on_unselect_enemy.emit()
