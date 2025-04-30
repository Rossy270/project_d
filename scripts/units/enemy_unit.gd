extends Unit
class_name EnemyUnit

@export var id := -1

func _ready() -> void:
	super._ready()
	add_to_group("enemy")


func _exit_tree() -> void:
	remove_from_group("enemy")
