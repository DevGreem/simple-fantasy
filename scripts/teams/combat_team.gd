extends Node

class_name CombatTeam

@onready var enemies_team: CombatTeam:
	get:
		return self.combat.get_other_team(self)

@onready var allies := get_allies()

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
	
	for children in self.allies:
		children.team = self
	
	#prints("Started team: ", self.name)

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

func get_available_allies(ant_ans := 0) -> Array[CombatEntity]:
	
	var _allies := self.get_alive_allies()
	
	var available := _allies.filter(
		func(entity: CombatEntity): return not entity.was_played
	)
	
	if available.is_empty():
		_reset_played_characters()
		return get_available_allies(ant_ans)
	
	return available

func get_ally(index: int) -> CombatEntity:
	return self.allies[index]

func get_alive_ally(index: int) -> CombatEntity:
	return self.get_alive_allies()[index]

func _reset_played_characters() -> void:
	
	for character in self.allies:
		character.was_played = false
