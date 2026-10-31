extends Active

func a_action() -> void:
	Action.set_action(Action.ActionType.ABILITY, Action.Targets.ALL, Action.Restriction.ALIVE, false)
	source.action_menu.cancelBtn.show()
	Events.choose_target.emit()

func a_ability(t: Character) -> void:
	t.status_manager.grant_status("cursed")
	_pay_cost()
	source.end_of_turn()
