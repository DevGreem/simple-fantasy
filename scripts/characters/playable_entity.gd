extends CombatEntity

class_name PlayableEntity

@export var run_percent: float = 0.2

var playable_team: PlayerTeam:
	get:
		return team

func attack(__: int = 0):
	prints("Attacking to enemy: ", self.playable_team.selected_enemy)
	super.attack(self.playable_team.selected_enemy)
