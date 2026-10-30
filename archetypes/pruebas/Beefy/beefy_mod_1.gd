extends Modifier

func temp_end() -> int:
	if source.stats.hp <= source.stats.max_hp / 2:
		return t_end
	return 0
