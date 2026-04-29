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

var _was_blocking := false
	
func _ready() -> void:
	super._ready()
	_base_position = self.global_position
	on_be_selected.connect(select)
	on_be_unselected.connect(unselect)
	on_play.connect(unselect)
	animation_changed.connect(_debug_act_animation)
	_init_actions()

func _init_actions() -> void:
	
	for action in get_actions():
		action.on_before_make_action.connect(_on_make_action)

func _on_make_action(action: ActionBase) -> void:
	
	#prints("Detected action: ", action.action_name)
	if action.action_name == "Block":
		_was_blocking = true
	else:
		_was_blocking = false

func select() -> void:
	
	if is_currently_selected:
		return
	
	is_currently_selected = true
	
	_was_blocking = self.blocking
	self.unblock()
	
	self.play("walking")
	
	var tween := create_tween()
	tween.tween_property(self, "global_position", self.global_position-Vector2(100, 0), 0.25)
	
	await tween.finished
	
	self.play("idle")

func unselect() -> void:
	
	if not is_currently_selected:
		return
	
	is_currently_selected = false
	
	self.play("walking")
	self.flip_h = not flip_h
	
	var tween := create_tween()
	tween.tween_property(self, "global_position", self._base_position, 0.25)
	
	await tween.finished
	
	if _was_blocking:
		self.block()
	else:
		self.play("idle")
		
	self.flip_h = not flip_h

func _debug_act_animation():
	
	if animation == "attacking":
		print("ATTACK CALLED AGAIN")

func attack(__):
	#prints("Attacking to enemy: ", self.playable_team.selected_enemy)
	super.attack(self.playable_team.selected_enemy)
