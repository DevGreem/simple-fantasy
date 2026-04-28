extends CombatTeam

class_name PlayerTeam

signal on_change_character(index: int)
signal on_change_enemy(index: int)
signal on_select_character(character: PlayableEntity)
signal on_unselect_character
signal on_select_enemy(character: AIEntity)
signal on_unselect_enemy

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
		
		var selected_ally := self.get_selected_ally()
		
		if is_character_selected:
			on_select_character.emit(selected_ally)
			selected_ally.on_be_selected.emit()
		else:
			on_unselect_character.emit()
			selected_ally.on_be_unselected.emit()

var selected_enemy: int = 0:
	set(value):
		
		if value < 0 or value >= self.enemies_team.allies.size():
			return
		
		selected_enemy = value
		on_change_enemy.emit(value)

var is_enemy_selected: bool = false:
	set(value):
		
		is_enemy_selected = value
		
		if value:
			var selected_enemy_character = self.enemies_team.get_alive_ally(selected_enemy)
			on_select_enemy.emit(selected_enemy_character)
			selected_enemy_character.on_be_selected.emit()
		else:
			on_unselect_enemy.emit()

func get_selected_ally() -> PlayableEntity:
	
	var available := self.get_available_allies()
	
	if available.size() == 0:
		combat.manual_end(self)
		return
		
	return self.get_available_allies()[selected_character]
