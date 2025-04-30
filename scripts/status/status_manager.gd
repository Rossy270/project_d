extends Node
class_name StatusManger

#Gerencia a aplicação e remoção de efeitos de status em um alvo

var _active_effect: Array[StatusEffect] = []

func apply_effect(target: Unit, effect: StatusEffect, source: Unit = null) -> void:
	if not target.has_meta("status_modifiers"):
		target.set_meta("status_modifiers", {})
	
	effect.source = source
	_active_effect.append(effect)
	effect.apply(target)


func update_effects(target: Unit) -> void:
	for effect in _active_effect.duplicate():
		effect.update(target)
		if effect.turns_remaining <= 0:
			_active_effect.erase(effect)


func clear_effects(target: Unit) -> void:
	if not target.has_meta("status_modifiers"):
		return
	
	var status_modifiers: Dictionary = target.get_meta("status_modifiers")
	for effect in status_modifiers.keys():
		effect.remove(target)
	
	_active_effect.clear()
	target.set_meta("status_modifiers", {})
