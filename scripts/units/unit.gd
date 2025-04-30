extends Node2D
class_name Unit

signal action_finished(action_name)

@export var move_points := 1
@export var stats: BaseStats
@export var actions: Array[UnitAction]
@export var is_player_controlled := false
@export var sprite: Sprite2D

var grid: Grid
var cell := Vector2i.ZERO:
	set(value):
		cell = grid.grid_clamp(value)
		position = grid.calculate_map_position(cell)
var is_selected := false
var current_action: UnitAction = null


func _ready() -> void:
	if not stats:
		stats = BaseStats.new()
	else:
		stats = stats.duplicate()
	
	stats.reinitialize()


func initializer(_grid: Grid) -> void:
	grid = _grid
	cell = grid.calculate_grid_coordinates(position)
	grid.set_cell_occupied(cell, self)
	CombatObserver.register_unit(self)


func execute_action(action: UnitAction) -> void:
	if current_action:
		print("Unit is already performing an action.")
		return
	
	current_action = action
	current_action.action_finished.connect(_on_action_finished)
	action.start(self)


func _on_action_finished(action_name: String) -> void:
	current_action.action_finished.disconnect(_on_action_finished)
	current_action = null
	action_finished.emit(action_name)
