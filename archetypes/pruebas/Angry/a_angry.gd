extends Active

func a_action() -> void:
	Action.set_action(Action.ActionType.ABILITY, Action.Targets.ALL, Action.Restriction.TARGET, true)
	source.action_menu.cancelBtn.show()
	Events.choose_target.emit()

func a_ability(targets: Array[Character]) -> void:
	var save : bool = true
	for target in targets:
		if !GL.allies_o_enemies(source, target):
			save = ability_save(target)
		if !save:
			target.status_manager.grant_status("enraged")
		else:
			print("failed ability")
	
	_pay_cost()
	source.end_of_turn()
