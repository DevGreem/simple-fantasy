extends CombatTeam

class_name PlayerTeam

signal on_change_character(index: int)
signal on_change_enemy(index: int)
signal on_select_character(character: PlayableEntity)
signal on_unselect_character

var selected_character: int = 0:
	set(value):
		
		if value < 0:
			value = self.get_available_allies().size()-1
		
		if value >= self.get_available_allies().size():
			value = 0
		
		selected_character = value
		on_change_character.emit(value)

var is_character_selected: bool = false:
	set(value):
		
		is_character_selected = value
		
		if value:
			on_select_character.emit(self.get_selected_ally())
		else:
			on_unselect_character.emit()

var selected_enemy: int = 0:
	set(value):
		
		if value < 0 or value >= len(self.enemies_team.allies):
			return
		
		selected_enemy = value
		on_change_enemy.emit(value)

func get_selected_ally():
	return self.get_available_allies()[selected_character]
