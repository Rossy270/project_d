extends UnitAction
class_name MoveAction

@export var move_speed := 50.0

var _path: Array
var _path_index := 0
var _is_moving := false
var _tween: Tween
var grid: Grid
var sprite: Sprite2D

func _init(path: Array) -> void:
	_path = path


func start(unit: Unit) -> void:
	grid = unit.grid
	sprite = unit.sprite
	
	if not unit is Unit:
		printerr("MoveAction: Unit must be of type Unit")
		return
	
	if _path.is_empty():
		printerr("MoveAction: Path is empty")
		return
	
	_is_moving = true
	_path_index = 0
	_walk_to_next(unit)


func update(_delta: float) -> void:
	pass


func _walk_to_next(unit: Unit) -> void:
	if _path_index >= _path.size():
		_is_moving = false
		action_finished.emit("move")
		return
	
	var next_cell = _path[_path_index]
	var next_pos = grid.calculate_map_position(next_cell)
	var distance = unit.position.distance_to(next_pos)
	var duration = distance / move_speed
	
	var direction = next_pos - unit.position
	sprite.flip_h = direction.x < 0
	
	_tween = unit.create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(unit, "position", next_pos, duration)
	
	await _tween.finished
	
	unit.cell = next_cell
	_path_index += 1
	_walk_to_next(unit)
