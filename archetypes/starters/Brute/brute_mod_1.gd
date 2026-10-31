extends Modifier

func dmg_multiplier(origin : Character , target : Character) -> float:
	print("que ha pasao")
	print("aff: "+ char_affected.stats.char_name)
	print("target: " + target.stats.char_name)
	print("origin: " + origin.stats.char_name)
	if(GL.allies_o_enemies(char_affected, source) && char_affected == target && origin.status_manager.check_status("fragile")):
		
		return dmg_mult
	else:
		return 1
	return 1
