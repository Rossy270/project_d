extends TileMapLayer
class_name Map

const INVALID_CELL = 999999

#Cache para armazenar os curstos dos vizinhos
var _cost_cache: Dictionary = {}

func _init() -> void:
	_cost_cache.clear()


func get_movement_cost(from_cell: Vector2i, to_cell: Vector2i) -> int:
	var cost_key = str(from_cell) + ", " + str(to_cell)
	
	if _cost_cache.has(cost_key):
		return _cost_cache[cost_key]
	
	#Pega o custo do tile de destino.
	var tile_data = get_cell_tile_data(to_cell)
	var cost = 1
	
	if tile_data:
		cost = tile_data.get_custom_data("cost")
		if cost == null or cost <= 0:
			cost = INVALID_CELL
	
	_cost_cache[cost_key] = cost
	
	return cost


func clear_cost_cache() -> void:
	_cost_cache.clear()
