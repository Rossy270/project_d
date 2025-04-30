extends Resource
class_name Grid

var _current_map: Map
var _occupied_cells: Dictionary = {}


func set_current_map(map: Map) -> void:
	if map == _current_map:
		return
	
	_current_map = map
	_occupied_cells.clear()


func calculate_map_position(grid_position: Vector2i) -> Vector2:
	return _current_map.map_to_local(grid_position)


func calculate_grid_coordinates(map_position: Vector2) -> Vector2i:
	return _current_map.local_to_map(map_position)


func get_cell_size() -> Vector2:
	return _current_map.tile_set.tile_size


func get_moveable_cells() -> PackedVector2Array:
	return _current_map.get_used_cells_by_id(0)


func as_index(cell: Vector2i) -> int:
	var size = _current_map.get_used_rect().size
	return cell.x + size.x * cell.y


func is_cell_occupied(cell: Vector2i) -> bool:
	return _occupied_cells.has(cell)


func set_cell_occupied(cell: Vector2i, unit: Node2D) -> void:
	_occupied_cells[cell] = unit


func set_cell_free(cell: Vector2i) -> void:
	_occupied_cells.erase(cell)


func _is_valid_tile(grid_position: Vector2i) -> bool:
	var tile_data = _current_map.get_cell_tile_data(grid_position)
	if tile_data and tile_data.get_custom_data("cost") > 0:
		return true
	return false


func _find_nearest_valid_tile(grid_position: Vector2i) -> Vector2i:
	var max_radius = 10
	var nearest_tile = grid_position
	var min_distance = INF
	
	for radius in range(1, max_radius + 1):
		for x in range(-radius, radius + 1):
			for y in range(-radius, radius + 1):
				if abs(x) != radius and abs(y) != radius:
					continue
				
				var cell = Vector2i(grid_position.x + x, grid_position.y + y)
				
				if _is_valid_tile(cell):
					var distance = grid_position.distance_to(cell)
					if distance < min_distance:
						min_distance = distance
						nearest_tile = cell
		if min_distance != INF:
			return nearest_tile
	
	return grid_position


func is_within_bounds(cell: Vector2i) -> bool:
	return _is_valid_tile(cell)


func grid_clamp(cell: Vector2i) -> Vector2i:
	if _is_valid_tile(cell):
		return cell
	return _find_nearest_valid_tile(cell)


func calculate_path(start: Vector2i, goal: Vector2i, valid_cells: Array = []) -> Array:
	if not is_within_bounds(start) or not is_within_bounds(goal):
		return []
	
	if start == goal:
		return [start]
	
	var open_set = [start]
	var came_from: Dictionary = {}
	var g_score: Dictionary = {start: 0}
	var f_score: Dictionary = {start: _heuristic_cost_estimate(start, goal)}
	
	while not open_set.is_empty():
		var current = _get_node_with_lowest_f_score(open_set, f_score)
		if current == goal:
			return _reconstruct_path(came_from, current, start)
		
		open_set.erase(current)
		
		var neighbors = _get_neighbors(current)
		for neighbor in neighbors:
			if not is_within_bounds(neighbor) or is_cell_occupied(neighbor) or (valid_cells.size() > 0 and neighbor not in valid_cells): # Verifica se está em valid_cells
				continue
			
			# Obtém o custo de movimento do vizinho da classe Map
			var move_cost = _current_map.get_movement_cost(current, neighbor)
			var tentative_g_score = g_score.get(current, INF) + move_cost
			
			if tentative_g_score < g_score.get(neighbor, INF):
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g_score
				f_score[neighbor] = tentative_g_score + _heuristic_cost_estimate(neighbor, goal)
				if neighbor not in open_set:
					open_set.append(neighbor)
	
	return []


# Função para encontrar o nó com o menor valor de f_score
func _get_node_with_lowest_f_score(nodes: Array, f_scores: Dictionary) -> Vector2i:
	var lowest_f_score = INF
	var lowest_node: Vector2i
	for node in nodes:
		var f_score = f_scores.get(node, INF)
		if f_score < lowest_f_score:
			lowest_f_score = f_score
			lowest_node = node
	return lowest_node


func _heuristic_cost_estimate(start: Vector2i, goal: Vector2i) -> int:
	return abs(goal.x - start.x) + abs(goal.y - start.y)


func _reconstruct_path(came_from: Dictionary, current: Vector2i, start: Vector2i) -> Array:
	var path: Array[Vector2i] = []
	var current_node = current
	while came_from.has(current_node):
		path.append(current_node)
		current_node = came_from[current_node]
	path.append(start)
	path.reverse()
	return path


func _get_neighbors(node: Vector2i) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	neighbors.append(Vector2i(node.x + 1, node.y))
	neighbors.append(Vector2i(node.x - 1, node.y))
	neighbors.append(Vector2i(node.x, node.y + 1))
	neighbors.append(Vector2i(node.x, node.y - 1))
	return neighbors
