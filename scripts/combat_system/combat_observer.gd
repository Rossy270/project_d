extends Node

signal attack_occurred(attacker, defender, attack)
signal unit_for_combat(unit)


func register_attacker(attacker: Node2D, defender: Node2D, attack: Node2D) -> void:
	attack_occurred.emit(attacker, defender, attack)


func register_unit(unit: Unit) -> void:
	unit_for_combat.emit(unit)
