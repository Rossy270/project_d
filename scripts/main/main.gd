extends Node2D
class_name Main

@export var grid: Grid
@export var map: Map

func _ready() -> void:
	print("chamei ", name)
	grid.set_current_map(map)
