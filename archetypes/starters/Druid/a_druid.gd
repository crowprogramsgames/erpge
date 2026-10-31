extends Active

func a_action():
	Action.set_action(Action.ActionType.ABILITY, Action.Targets.ALLY, Action.Restriction.TARGET, false)
	Events.choose_target.emit()

func a_ability(targets : Array[Character]) -> void:
	
	for target in targets:
		await target.status_manager.grant_status("protected")
	_pay_cost()
	source.end_of_turn()
