extends Step

var path_utils: PathfinderUtils
var unit: Unit

var available_cells := []

func enter(_msg := {}) -> void:
	unit = manager.current_unit
	path_utils = PathfinderUtils.new(unit.grid)
	
	available_cells = path_utils.get_reachable_cells(unit.cell, unit.stats.move_range)
	
	GameBoardOverlay.show_available_cells(available_cells)
	GameBoardOverlay.path_choice.connect(_on_path_choice)


func process(_delta: float) -> void:
	GameBoardOverlay.draw_user_path(unit)


func exit() -> void:
	GameBoardOverlay.clear_user_path()
	GameBoardOverlay.clear_available_cells()
	GameBoardOverlay.path_choice.disconnect(_on_path_choice)
	path_utils = null


func _on_path_choice(path) -> void:
	if path.is_empty():
		print("Não tem caminho!")
		return
	
	var move_action =  MoveAction.new(path)
	
	unit.execute_action(move_action)
	
	await unit.action_finished
	
	manager.go_to_next_step("%ChoosingAction")
