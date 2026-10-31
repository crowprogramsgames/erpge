extends Modifier

func additional_damage(o:Character, t:Character) -> int:
	print(str(source.tot_stat("fin") - t.tot_stat("fin")))
	return source.tot_stat("fin") - t.tot_stat("fin")
