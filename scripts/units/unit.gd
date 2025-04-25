@tool
extends Node2D
class_name Unit

signal walk_finished

@export var skin: Texture:
	set(value):
		skin = value
		_sprite.texture = value
@export var move_range := 6
@export var move_speed := 600.0

var grid: Grid
var cell := Vector2i.ZERO:
	set(value):
		cell = grid.grid_clamp(value)
		position = grid.calculate_map_position(cell)
var is_selected := false
var _tween: Tween

var _is_walking := false
var _path: PackedVector2Array
var _path_index := 0

@onready var _sprite: Sprite2D = $Texture

func setup(_grid: Grid) -> void:
	grid = _grid
	cell = grid.calculate_grid_coordinates(position)


func walk_along(path: PackedVector2Array) -> void:
	print(path)
	if path.is_empty():
		return
	
	_path = path
	_path_index = 0
	_is_walking = true
	_walk_to_next()


func _walk_to_next() -> void:
	if _path_index >= _path.size():
		_is_walking = false
		walk_finished.emit()
		return
	
	var next_cell = _path[_path_index]
	var nex_pos = grid.calculate_map_position(next_cell)
	var distance = position.distance_to(nex_pos)
	var duration = distance / move_speed
	
	var direction = nex_pos - position
	_sprite.flip_h = direction.x < 0
	
	_tween = create_tween()
	_tween.tween_property(self, "position", nex_pos, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	await _tween.finished
	
	cell = next_cell
	_path_index += 1
	_walk_to_next()
