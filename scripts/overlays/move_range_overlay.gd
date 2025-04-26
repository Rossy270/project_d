extends TileMapLayer
class_name MoveRangeOverlay

func draw(cells: Array) -> void:
	for cell in cells:
		set_cell(cell, 0, Vector2i(0,0))
