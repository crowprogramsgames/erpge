extends Active

@export var pwr_mult : float = 3

func a_action() -> void:
	Action.set_action(Action.ActionType.ABILITY, Action.Targets.ALL, Action.Restriction.TARGET, true)
	source.action_menu.cancelBtn.show()
	Events.choose_target.emit()

func a_ability(targets: Array[Character]) -> void:
	for target in targets:
		target.status_manager.grant_status("healing")
		target.heal(source.tot_stat("pwr") * pwr_mult)
	_pay_cost()
	source.end_of_turn()
