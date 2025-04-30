extends RefCounted
class_name KnowledgeSystem

var knowledge := {}

func _init() -> void:
	knowledge = {}


func get_monster_knowledge(monster_id: int) -> int:
	return knowledge.get(monster_id, 0)


func add_monster_knowledge(monster_id: int, amount: int) -> void:
	var current_knowledge = knowledge.get(monster_id, 0)
	knowledge[monster_id] = current_knowledge + amount


func calculate_critical_hit_bonus(monster_id: int) -> float:
	var knowledge_level = get_monster_knowledge(monster_id)
	return knowledge_level * 0.01


func calculate_evasion_hit_bonus(monster_id: int) -> float:
	var knowledge_level = get_monster_knowledge(monster_id)
	return knowledge_level * 0.01


func clear_knowledge() -> void:
	knowledge.clear()
