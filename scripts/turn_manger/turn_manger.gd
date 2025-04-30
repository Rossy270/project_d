extends Node
class_name TurnManager

@export var initial_step: NodePath

var party: Array
var enemies: Array

var queue: Array

var step: Step
var is_battler: bool = false
 
@export var current_unit: Unit

func _ready() -> void:
	step = get_node(initial_step)


func _process(delta: float) -> void:
	step.process(delta)


func go_to_next_step(step_name: String, msg := {}) -> void:
	if not has_node(step_name):
		return
	
	
	step.exit()
	step = get_node(step_name)
	step.enter(msg)
