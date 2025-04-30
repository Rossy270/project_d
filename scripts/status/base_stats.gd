extends Resource
class_name BaseStats

const UPGRADABLE_STATS = [
	"perception", "agility", "strength", "dexterity", "vitality", "cunning"
]

signal health_depleted

@export_category("Base Stats")
@export var base_vitality := 10.0
@export var base_strength := 10.0
@export var base_dexterity := 10.0
@export var base_perception := 10.0
@export var base_cunning := 10.0
@export var base_agility := 10.0

var max_health := 0
var health := 0:
	set(value):
		health = value
		if health <= 0:
			health_depleted.emit()
var move_range := 1
var perception := base_perception
var strength := base_strength
var dexterity := base_dexterity 
var vitality := base_vitality
var cunning := base_cunning 
var agility := base_agility

var _modifiers := {}
var _modifiers_sum := {}
var _modifeirs_id_counter := 0

func _init() -> void:
	for stat in UPGRADABLE_STATS:
		_modifiers[stat] = {}
		_modifiers_sum[stat] = 0


func reinitialize() -> void:
	# Reinicializa os atributos para seus valores base.
	perception = base_perception
	agility = base_agility
	strength = base_strength
	dexterity = base_dexterity
	vitality = base_vitality
	cunning = base_cunning
	for stat in UPGRADABLE_STATS:
		_modifiers_sum[stat] = 0
		_recalculate_stat(stat)
	
	_calculate_health()


func _recalculate_stat(stat: String) -> void:
	var base_value: float = get("base_" + stat)
	var final_value = base_value + _modifiers_sum[stat]
	
	var bonus = 0
	if final_value > 10:
		bonus = floor((final_value - 10) / 2)
	
	if stat == "vitality":
		vitality = final_value + bonus
		_calculate_health()
	elif stat == "perception":
		perception = final_value + bonus
	elif stat == "agility":
		agility = final_value + bonus
		move_range += floor(agility - 10) / 2
	elif stat == "strength":
		strength = final_value + bonus
	elif stat == "dexterity":
		dexterity = final_value + bonus
	elif stat == "cunning":
		cunning = final_value + bonus


func add_modifier(stat_name: String, value: float) -> int:
	if not _modifiers.has(stat_name):
		printerr("'Stat name' " + stat_name + " ' is not valid.' ")
		return -1
	
	_modifeirs_id_counter += 1
	var id := _modifeirs_id_counter
	
	_modifiers[stat_name][id] = value
	_modifiers_sum[stat_name] += value
	_recalculate_stat(stat_name)
	
	return id


func remove_modifier(stat_name: String, id: int) -> void:
	if not _modifiers.has(stat_name):
		printerr("'Stat name' " + stat_name + " ' is not valid.' ")
		return
	
	if not _modifiers[stat_name].has(id):
		printerr("Modifier with id '" + str(id) + "' for stat '" + stat_name + "' does not exist.")
		return
	
	var value = _modifiers[stat_name][id]
	_modifiers[stat_name].erase(id)
	_modifiers_sum[stat_name] -= value
	_recalculate_stat(stat_name)


func get_all_attributes() -> Dictionary:
	var attributes = {
		"perception": perception,
		"agility": agility,
		"strength": strength,
		"dexterity": dexterity,
		"vitality": vitality,
		"cunning": cunning,
		"health": health,
		"max_health": max_health,
	}
	return attributes


func _calculate_health() -> void:
	max_health = 50 + vitality + (10 * floor(vitality - 10) / 2)
	health = max_health
