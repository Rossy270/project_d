extends Node2D

@onready var move_range_overlay: MoveRangeOverlay = $MoveRangeOverlay
@onready var unit_path_overlay: UnitPathOverlay = $UnitPathOverlay

signal path_choice(path)

var unit: Unit


func show_available_cells(cells: Array) -> void:
	move_range_overlay.draw(cells)


func clear_available_cells() -> void:
	move_range_overlay.clear()


func draw_user_path(unit: Unit) -> void:
	if not unit_path_overlay.is_initializer:
		unit_path_overlay.initialize(unit.grid)
		CursorObeserve.cursor_pressed.connect(_on_cursor_pressed)
	
	unit_path_overlay.draw(unit.cell, CursorObeserve.get_cursor_moved_pos(), unit.stats.move_range)


func clear_user_path() -> void:
	unit_path_overlay.clear()
	CursorObeserve.cursor_pressed.disconnect(_on_cursor_pressed)


func _on_cursor_pressed() -> void:
	path_choice.emit(unit_path_overlay.current_path)
