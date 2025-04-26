extends Node2D
class_name Main

@export var grid: Grid

@onready var default_map: Map = $DefaultMap
@onready var cursor: Cursor = $Cursor
@onready var unit: Unit = $Unit
@onready var unit_path_overlay: UnitPathOverlay = $UnitPathOverlay
@onready var move_range_overlay: MoveRangeOverlay = $MoveRangeOverlay

var last_mouse_cell := Vector2i.ZERO
var path_utils: PathfinderUtils

func _ready() -> void:
	grid.set_current_map(default_map)
	cursor.setup()
	cursor.moved.connect(_on_cursor_moved)
	cursor.accept_pressed.connect(_on_cursor_accept_pressed)
	unit_path_overlay.initialize(grid)
	path_utils = PathfinderUtils.new(grid)
	move_range_overlay.draw(path_utils.get_reachable_cells(unit.cell, unit.move_range))


func _on_cursor_moved(cell: Vector2i) -> void:
	if cell == last_mouse_cell:
		return
		
	unit_path_overlay.clear()
	last_mouse_cell = cell
	
	unit_path_overlay.draw(unit.cell, cell, unit.move_range)


func _on_cursor_accept_pressed(cell: Vector2i) -> void:
	move_range_overlay.clear()
	unit_path_overlay.stop()
	var path = grid.calculate_path(unit.cell, cell)
	
	var move_action = MoveAction.new(path)
	
	unit.execute_action(move_action)
	
	await unit.action_finished
	
	move_range_overlay.draw(path_utils.get_reachable_cells(unit.cell, unit.move_range))
