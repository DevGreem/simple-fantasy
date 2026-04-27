extends Node

class_name CombatTeam

@onready var parent: CombatScene:
	get:
		return self.get_parent()

@onready var enemies_team: CombatTeam:
	get:
		return self.parent.get_other_team(self)

@onready var allies: Array[CombatEntity]:
	get:
		return self.get_allies()

var combat: CombatScene:
	set(value):
		
		_on_set_combat()
		combat = value
		_on_combat_ready()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	for children in self.allies:
		
		children.team = self
	
	prints("Started team: ", self.name)

func _on_set_combat():
	pass

func _on_combat_ready():
	pass

func get_allies() -> Array[CombatEntity]:
	print("Reading allies...")
	var allies_array: Array[CombatEntity] = []
	
	for children in self.get_children(true):
		
		prints("Reading children: ", children)
		if children is CombatEntity:
			print("Children is an ally")
			allies_array.append(children)
	
	return allies_array

func get_available_allies() -> Array[CombatEntity]:
	
	var _allies := self.allies
	
	if _allies.size() == 0:
		return []
	
	var available := _allies.filter(
		func(entity: CombatEntity): return not entity.was_played
	)
	
	if available.is_empty():
		_reset_played_characters()
		return get_available_allies()
	
	return available

func get_ally(index: int) -> CombatEntity:
	return self.allies[index]

func _reset_played_characters() -> void:
	
	for character in self.allies:
		character.was_played = false
		
