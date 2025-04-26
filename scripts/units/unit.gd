extends Node2D
class_name Unit

signal action_finished(action_name)

@export var move_range := 6
@export var attack_range := 1
@export var grid: Grid
@onready var sprite: Sprite2D = $Texture

var cell := Vector2i.ZERO:
	set(value):
		cell = grid.grid_clamp(value)
		position = grid.calculate_map_position(cell)
var is_selected := false
var current_action: UnitAction = null


func _ready() -> void:
	grid.grid_update.connect(_on_grid_update)


func execute_action(action: UnitAction) -> void:
	if current_action:
		print("Unit is already performing an action.")
		return
	
	current_action = action
	current_action.action_finished.connect(_on_action_finished)
	action.start(self)


func _on_grid_update() -> void:
	cell = grid.calculate_grid_coordinates(position)
	position = grid.calculate_map_position(cell)


func _on_action_finished(action_name: String) -> void:
	current_action.action_finished.disconnect(_on_action_finished)
	current_action = null
	action_finished.emit(action_name)
