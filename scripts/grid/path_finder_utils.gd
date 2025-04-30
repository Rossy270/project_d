extends RefCounted
class_name PathfinderUtils

var _grid: Grid

func _init(grid: Grid):
	_grid = grid

func get_reachable_cells(start_cell: Vector2i, move_points: int, ignore_occupancy: bool = false) -> Array:
	var reachable_cells := [start_cell]
	var visited_cells := {start_cell: 0}  # Dicionário: célula -> custo para alcançar
	var cells_to_explore := [start_cell]
	
	while cells_to_explore.size() > 0:
		var current_cell = cells_to_explore.pop_front()
		var current_cost = visited_cells[current_cell]
		
		for neighbor in _grid._get_neighbors(current_cell):
			if not _grid.is_within_bounds(neighbor):
				continue
			
			if not ignore_occupancy and _grid.is_cell_occupied(neighbor):
				continue
			
			var cost_to_neighbor = _grid._current_map.get_movement_cost(current_cell, neighbor)
			var new_cost = current_cost + cost_to_neighbor
			
			if new_cost <= move_points:
				if not visited_cells.has(neighbor) or new_cost < visited_cells[neighbor]:
					reachable_cells.append(neighbor)
					visited_cells[neighbor] = new_cost
					cells_to_explore.append(neighbor)
	
	return reachable_cells
