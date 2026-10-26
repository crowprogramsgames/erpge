extends Active

func a_action(o : Character) -> void:
	Action.set_action(Action.ACTION.ABILITY, Action.SELECTABLE.NONE, Action.RESTRICTION.ALIVE)
	a_ability(o, o)

func a_ability(o: Character, t: Character) -> void:
	
	t.status_manager.grant_status("enraged", t)
	pay_cost(o)
	o.passive.end_of_turn(o)
