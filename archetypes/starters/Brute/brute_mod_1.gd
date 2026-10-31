extends Modifier

func dmg_multiplier(origin : Character , target : Character) -> float:
	if(GL.allies_o_enemies(char_affected, source) && char_affected == target && origin.status_manager.check_status("fragile")):
		return dmg_mult
	else:
		return 1
