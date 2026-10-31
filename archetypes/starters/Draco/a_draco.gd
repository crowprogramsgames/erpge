extends Active

@export var pwr_mult : float = 2

func a_action():
	Action.set_action(Action.ActionType.ABILITY, Action.Targets.ENEMY, Action.Restriction.TARGET, false)
	Events.choose_target.emit()

func a_ability(targets : Array[Character]) -> void:
	var save : bool
	var dmg : int
	for target in targets:
		save = ability_save(target)
		if !save:
			dmg = GL.ab_damage(source, target, source.tot_stat("pwr") * pwr_mult)
			target.be_dealt_dmg(dmg)
		else:
			target.be_dealt_dmg(source.tot_stat("pwr") * pwr_mult / 2)
			print("failed ability")
	_pay_cost()
	source.end_of_turn()
