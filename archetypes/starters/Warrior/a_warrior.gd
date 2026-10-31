extends Active

func a_action() -> void:
	Action.set_action(Action.ActionType.ABILITY, Action.Targets.ENEMY, Action.Restriction.TARGET, true)
	source.action_menu.cancelBtn.show()
	Events.choose_target.emit()

func a_ability(targets: Array[Character]) -> void:
	var roll = 20
	var hit_data : Array[float]
	var hit_mult : float
	var pre_bonus : float 
	
	for target in targets:
		if target.status_manager.check_status("protected"):
			target.status_manager.grant_status("fragile")
		else:
			hit_data  = GL.hit(roll, source, target)
			hit_mult = hit_data[0]
			pre_bonus = hit_data[1]
			
			if hit_mult == -1:
				pass
			else:
				var dmg : int = GL.atk_damage(pre_bonus, hit_mult, source, target)
				print(source.stats.char_name + " has dealt " + str(dmg) + " damage to " + target.stats.char_name)
				target.be_dealt_dmg(dmg)
				if(dmg > 0):
					Events.attack_hit.emit(source, target)
	_pay_cost()
	source.end_of_turn()
