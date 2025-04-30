extends Node2D
class_name Main

@export var grid: Grid
@export var map: Map
@onready var turn_manager: TurnManager = $TurnManager

@export var units: Array[Unit]


func _ready() -> void:
	grid.set_current_map(map)
	
	for unit in units:
		unit.initializer(grid)
	
	CursorObeserve.active_cursor(grid)
	turn_manager.step.enter()
