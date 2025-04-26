extends Resource
class_name UnitAction

signal action_started(unit)
signal action_finished

func start(unit: Unit) -> void:
	action_started.emit(unit)


func update(_delta: float) -> void:
	pass
