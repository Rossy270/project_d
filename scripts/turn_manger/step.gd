extends Node
class_name Step

@onready var manager: TurnManager = _get_turn_manager(self)

func _get_turn_manager(node: Node) -> TurnManager:
	if node != null and not node is TurnManager:
		return _get_turn_manager(node.get_parent())
	
	return node


func enter(_msg := {}) -> void:
	pass


func exit() -> void:
	pass


func process(_delta: float) -> void:
	pass
