extends BaseStats
class_name HeroStats

var knowledge: KnowledgeSystem

func _init() -> void:
	# Inicializa o sistema de conhecimento e gera os atributos do jogador.
	super._init()
	knowledge = KnowledgeSystem.new()
	randomize_attributes()


func reinitialize() -> void:
	# Reinicializa os atributos e o sistema de conhecimento do jogador.
	super.reinitialize()
	randomize_attributes()
	for stat in UPGRADABLE_STATS: # Recalcula os status após a randomização
		_recalculate_stat(stat)
	_calculate_health() # Recalcula a vida também


func randomize_attributes() -> void:
	# Gera valores aleatórios para os atributos do jogador.
	var rolls := []
	for _i in range(6):
		var roll := []
		for _j in range(4):
			roll.append(randi_range(1, 6))
		roll.sort()
		roll.pop_front()
		var roll_sum = 0
		for r in roll:
			roll_sum += r
		rolls.append(roll_sum)

	rolls.sort()

	var prioritized_stats = []
	var high_value_count = 2
	var low_value_count = 4
	var remaining_stats = UPGRADABLE_STATS.duplicate()
	
	for i in range(high_value_count):#atribui os 2 maiores rolls aos stats priorizados
		if remaining_stats.size() > 0:
			var stat_index = randi_range(0, remaining_stats.size() - 1)
			var stat_name = remaining_stats.pop_at(stat_index)
			prioritized_stats.append(stat_name)
	
	for i in range(high_value_count):
		var stat_name = prioritized_stats[i]
		var roll_value = rolls.pop_back()
		roll_value = clamp(roll_value, 11, 20)  # Limita os valores altos entre 11 e 20
		set("base_" + stat_name, roll_value)
			

	for i in range(low_value_count):
		if remaining_stats.size() > 0:
			var stat_index = randi_range(0, remaining_stats.size() - 1)
			var stat_name = remaining_stats.pop_at(stat_index)
			var roll_value = rolls.pop_front()
			roll_value = clamp(roll_value, 5, 10)  # Limita os valores baixos entre 1 e 10
			set("base_" + stat_name, roll_value)

	if base_vitality < 20:
		base_vitality = 20
	if base_strength < 3:
		base_strength = 3
	if base_dexterity < 3:
		base_dexterity = 3
	if base_perception < 3:
		base_perception = 3
	if base_cunning < 3:
		base_cunning = 3
	if base_agility < 3:
		base_agility = 3
