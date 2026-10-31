extends Active

func a_action():
	Action.set_action(Action.ActionType.ABILITY, Action.Targets.ENEMY, Action.Restriction.TARGET, false)
	Events.choose_target.emit()

func a_ability(targets : Array[Character]) -> void:
	var save : bool
	for target in targets:
		save = ability_save(target)
		if !save:
			target.status_manager.grant_status("blinded")
		else:
			print("failed ability")
	_pay_cost()
	source.end_of_turn()
