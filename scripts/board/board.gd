extends Node2D
class_name Board

const DIRECTIONS = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
const MAX_DISTANCE = 99999


@export var grid_start: Vector2i = Vector2i(0,0)
@export var grid_end: Vector2i = Vector2i(20,20)
@export var grid: Grid

@onready var unit_path_overlay: UnitPathOverlay = $MapOverlay/UnitPathOverlay
@onready var default_map: Map = $MapOverlay/DefaultMap
@onready var cursor: Cursor = $Cursor

var _units := {}
var active_unit: Unit
var _walkable_cells := []
