class_name Manager
extends Node

var man_list : Array[Effect]


func add_effect(e : Effect):
	man_list.append(e)
func delete_effect(e : Effect):
	man_list.erase(e)

func tot_stat(type : String) -> float:
	var total : float = 0
	match type:
		"pwr":
			for effect in man_list:
				total += effect.temp_pow()
		"end":
			for effect in man_list:
				total += effect.temp_end()
		"fin":
			for effect in man_list:
				total += effect.temp_fin()
		"ref":
			for effect in man_list:
				total += effect.temp_ref()
		"vir":
			for effect in man_list:
				total += effect.temp_vir()
		"ini":
			for effect in man_list:
				total += effect.temp_ini()
		"pwr_rng":
			for effect in man_list:
				total += effect.pwr_range()
		"pre_rng":
			for effect in man_list:
				total += effect.pre_range()
		"cri_rng":
			for effect in man_list:
				total += effect.crit_range()
		"end_rng":
			for effect in man_list:
				total += effect.end_range()
		"crit_mult":
			for effect in man_list:
				total += effect.crit_multiplier()
		"save":
			for effect in man_list:
				total += effect.save_val()
		_:
			return 0
	return total
func dmg_multiplier(o: Character, t:Character) -> float:
	var total : float = 1
	for effect in man_list:
		total *= effect.dmg_multiplier(o,t)
	return total
