extends Node2D
class_name Board


func get_walkable_cells(unit: Unit) -> Array:
	return _dijkstra(unit.cell, unit.move_range)


func _dijkstra(start: Vector2i, max_distance: int) -> Array:
	var movement_costs = Grid.get_movement_costs(grid_start, grid_end)
	
	var queue = PriorityQueue.new()
	var distances = {}
	var visited = {}
	var moveable_cells = [start]
	
	for coord in movement_costs:
		distances[coord] = MAX_DISTANCE
		visited[coord] = false
		distances[start] = 0
		
	queue.push(start, 0)
	
	while not queue.is_empty():
		var current = queue.pop()
		if visited[current.value]:
			continue
		visited[current.value] = true
		
		for direction in DIRECTIONS:
			var neighbor = current.value + direction
			
			if not movement_costs.has(neighbor) or movement_costs[neighbor] >= MAX_DISTANCE:
				continue
			
			if is_occupied(neighbor):
				continue
			
			var new_cost = current.priority + movement_costs[neighbor]
			if new_cost < distances[neighbor]:
				distances[neighbor] = new_cost
				if new_cost <= max_distance:
					moveable_cells.append(neighbor)
					queue.push(neighbor, new_cost)
	
	return moveable_cells
