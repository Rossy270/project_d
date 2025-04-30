extends Node

signal cursor_pressed

var cursor: Cursor

var c_last_pos: Vector2i


func register_cursor(_cursor: Cursor) -> void:
	cursor = _cursor
	cursor.accept_pressed.connect(_on_cursor_pressed)
	cursor.moved.connect(_on_cursor_moved)
	cursor.visible = false


func active_cursor(grid: Grid) -> void:
	cursor.setup(grid)


func _on_cursor_moved(pos: Vector2i) -> void:
	if pos == c_last_pos:
		return
	
	c_last_pos = pos


func get_cursor_moved_pos() -> Vector2i:
	return c_last_pos


func _on_cursor_pressed() -> void:
	cursor_pressed.emit()
