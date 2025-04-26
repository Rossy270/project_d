extends TileMapLayer
class_name UnitPathOverlay

var _grid: Grid
var current_path: Array
var _pathfinder: PathfinderUtils

func initialize(grid: Grid) -> void:
	_grid = grid
	_pathfinder = PathfinderUtils.new(_grid)


func draw(cell_start: Vector2i, cell_end: Vector2i, move_range: int) -> void:
	clear()
	
	var reachable_cells = _pathfinder.get_reachable_cells(cell_start, move_range)
	
	if cell_end in reachable_cells:
		current_path = _grid.calculate_path(cell_start, cell_end, reachable_cells)
		for cell in current_path:
			set_cell(cell, 0, Vector2i(0,0))
	else:
		current_path = []


func stop() -> void:
	clear()
