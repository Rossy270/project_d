extends Node2D
class_name Cursor

signal accept_pressed(cell)
signal moved(new_cell)

@export var ui_cooldown := 0.1
@export var grid: Grid

@onready var timer: Timer = $Timer

var _cell := Vector2i.ZERO

var cell := Vector2i.ZERO:
	set(value):
		var new_cell : Vector2i = grid.grid_clamp(value)
		
		var conf_new_cell = Vector2(new_cell.x, new_cell.y)
		var conf_cell = Vector2(cell.x, cell.y)
		
		if conf_new_cell.is_equal_approx(conf_cell):
			return
		
		_cell = new_cell
		position = grid.calculate_map_position(_cell)
		moved.emit(_cell)
		timer.start()

func _ready() -> void:
	print("chamei ", name)
	timer.wait_time = ui_cooldown
	
	if not grid.has_map():
		await grid.map_register
	
	position = grid.calculate_map_position(cell)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cell = grid.calculate_grid_coordinates(event.position)
	elif event.is_action_pressed("cursor_clicked"):
		accept_pressed.emit(cell)
		get_viewport().set_input_as_handled()
	
	var should_move := event.is_pressed()
	
	if event.is_echo():
		should_move = should_move and timer.is_stopped()
	
	if not should_move:
		return
	
	if event.is_action("cursor_right"):
		cell += Vector2i.RIGHT
	elif event.is_action("cursor_up"):
		cell += Vector2i.UP
	elif event.is_action("cursor_left"):
		cell += Vector2i.LEFT
	elif event.is_action("cursor_down"):
		cell += Vector2i.DOWN
