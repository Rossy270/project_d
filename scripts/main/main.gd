extends Node2D
class_name Main

@export var grid: Grid
@export var map: Map
@export var cursor: Cursor
@export var unit: Unit
@onready var unit_path_overlay: UnitPathOverlay = $UnitPathOverlay

var last_cursor_pos := Vector2i.ZERO

func _ready() -> void:
	grid.set_current_map(map)
	cursor.setup()
	unit.setup(grid)
	
	#var test = [Vector2i(3,2), Vector2i(3,3), Vector2i(3,4), Vector2i(4,4), Vector2i(5,4)]
	#var packed = PackedVector2Array(test)
	#
	#unit.walk_along(packed)
	var rect_start := Vector2(4, 4)
	var rect_end := Vector2(10, 8)

	# The following lines generate an array of points filling the rectangle from rect_start to rect_end.
	var points := []
	# In a for loop, writing a number or expression that evaluates to a number after the "in"
	# keyword implicitly calls the range() function.
	# For example, "for x in 3" is a shorthand for "for x in range(3)".
	for x in rect_end.x - rect_start.x + 1:
		for y in rect_end.y - rect_start.y + 1:
			points.append(rect_start + Vector2(x, y))
	
	unit_path_overlay.initialize(points, grid)
	
	unit_path_overlay.draw(rect_start, Vector2(8, 7))
