extends Modifier

func additional_damage(o:Character, t:Character) -> int:
	return source.tot_stat("fin") - t.tot_stat("fin")
