extends Resource
class_name StatusEffect

#Exemplos("Veneno", "Fúria")
@export var name: String = "Efeito de status"
@export var description: String = "Aplica um efeito de status"
@export var duration: int = 0
# Dicionário de modificadores de atributos (ex: {"attack": -10, "defense": 5}).
@export var modifiers: Dictionary = {}

var turns_remaining: int 
var source: Unit

func apply(target: Unit) -> void:
	var status_modifiers: Dictionary = target.get_meta("status_modifiers")
	
	if not status_modifiers:
		status_modifiers = {}
	
	if not status_modifiers.has(self):
		status_modifiers[self] = {}
	
	for stat_name in modifiers:
		var value = modifiers[stat_name]
		var id =  target.stats.add_modifier(stat_name, value)
		status_modifiers[self][stat_name] = id
	
	target.set_meta("status_modifiers", status_modifiers)
	
	turns_remaining = duration
	
	on_apply(target)



func update(target: Node) -> void:
	if duration > 0:
		turns_remaining -= 1
		if turns_remaining <= 0:
			remove(target)
	
	on_update(target)


func remove(target: Unit) -> void:
	var status_modifiers: Dictionary = target.get_meta("status_modifiers")
	
	if status_modifiers == null:
		return
	
	if status_modifiers.has(self):
		for stat_name in modifiers:
			var id = status_modifiers[self][stat_name]
			target.stats.remove_modifier(stat_name, id)
			target.set_meta("status_modifiers", status_modifiers)
	
	on_remove(target)


func on_apply(_target: Unit) -> void:
	pass


func on_update(_target: Unit) -> void:
	pass


func on_remove(_target: Unit) -> void:
	pass
