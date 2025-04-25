extends TileMapLayer
class_name UnitPathOverlay

var _pathfinder: PathFinder
var current_path := PackedVector2Array()


func initialize(walkable_cells: Array, grid: Grid) -> void:
	_pathfinder = PathFinder.new(walkable_cells, grid)


func draw(cell_start: Vector2i, cell_end: Vector2i) -> void:
	clear()
	current_path = _pathfinder.calculate_point_path(cell_start, cell_end)
	
	print(current_path)
	
	for cell in current_path:
		set_cell(cell, 0, Vector2i(0,0))


func stop() -> void:
	_pathfinder = null
	clear()
