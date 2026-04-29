extends Node

class_name CombatTeam

@onready var enemies_team: CombatTeam:
	get:
		return self.combat.get_other_team(self)

@onready var allies := self.get_allies()

var combat: CombatScene:
	set(value):
		_on_set_combat()
		combat = value
		_on_combat_ready()

func _on_set_combat():
	pass

func _on_combat_ready():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	child_entered_tree.connect(_on_child_added)
	
	for children in self.allies:
		children.team = self
	#prints("Started team: ", self.name)

func _on_child_added(node: Node):
	
	if node is CombatEntity:
		node.team = self

func get_allies() -> Array[CombatEntity]:
	#print("Reading allies...")
	var allies_array: Array[CombatEntity] = []
	
	for children in self.get_children(true):
		
		#prints("Reading children: ", children)
		if children is CombatEntity:
			#print("Children is an ally")
			allies_array.append(children)
	
	return allies_array

func get_alive_allies() -> Array[CombatEntity]:
	
	var alive := self.allies.filter(
		func(entity: CombatEntity): return entity.is_alive()
	)
	
	return alive

func get_died_allies() -> Array[CombatEntity]:
	
	var died := self.allies.filter(
		func(entity: CombatEntity): return not entity.is_alive()
	)
	
	return died

func get_available_allies() -> Array[CombatEntity]:
	
	var _allies := self.get_alive_allies()
	
	if _allies.size() == 0:
		return []
	
	var available := _allies.filter(
		func(entity: CombatEntity): return not entity.was_played
	)
	
	return available

func get_ally(index: int) -> CombatEntity:
	return self.allies[index]

func get_alive_ally(index: int) -> CombatEntity:
	return self.get_alive_allies()[index]

func _reset_played_characters() -> void:
	
	for character in self.allies:
		character.was_played = false

func start_turn() -> void:
	pass
