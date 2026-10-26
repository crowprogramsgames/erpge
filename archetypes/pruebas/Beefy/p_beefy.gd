extends Passive

var add_end : int = 6

func tot_end(o : Character) -> int:
	if o.hp >= o.max_hp / 2:
		return o.end + o.status.t_end + o.effect_manager.t_end()
	return o.end + o.status.t_end + o.effect_manager.t_end() + add_end
