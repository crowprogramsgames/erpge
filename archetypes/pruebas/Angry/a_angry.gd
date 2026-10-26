extends Active

func a_action(o : Character) -> void:
	Action.set_action(Action.ACTION.ABILITY, Action.SELECTABLE.ALL, Action.RESTRICTION.ALIVE)
	o.action_menu.cancelBtn.show()
	Events.choose_target.emit()

func a_ability(o: Character, t: Character) -> void:
	t.status_manager.grant_status("enraged", t)
	pay_cost(o)
	o.passive.end_of_turn(o)
