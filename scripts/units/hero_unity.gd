extends Unit
class_name HeroUnit

func _ready() -> void:
	if not stats:
		stats = HeroStats.new()
	stats = stats.duplicate()
	stats.reinitialize()
	add_to_group("party")


func _exit_tree() -> void:
	remove_from_group("party")
