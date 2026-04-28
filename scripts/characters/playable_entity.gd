extends CombatEntity

class_name PlayableEntity

signal on_be_selected
signal on_be_unselected

@export var run_percent: float = 0.2
var _base_position: Vector2

var is_currently_selected := false

var playable_team: PlayerTeam:
	get:
		return team
	
func _ready() -> void:
	super._ready()
	_base_position = self.global_position
	on_be_selected.connect(select)
	on_be_unselected.connect(unselect)
	on_play.connect(unselect)
	animation_changed.connect(_debug_act_animation)

func select() -> void:
	
	if is_currently_selected:
		return
	
	is_currently_selected = true
	
	self.unblock()
	
	var tween := create_tween()
	tween.tween_property(self, "global_position", self.global_position-Vector2(100, 0), 0.25)

func unselect() -> void:
	
	if not is_currently_selected:
		return
	
	is_currently_selected = false
	
	var tween := create_tween()
	tween.tween_property(self, "global_position", self._base_position, 0.25)

func _debug_act_animation():
	
	if animation == "attacking":
		print("ATTACK CALLED AGAIN")

func attack(__):
	#prints("Attacking to enemy: ", self.playable_team.selected_enemy)
	super.attack(self.playable_team.selected_enemy)
