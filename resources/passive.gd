class_name Passive
extends Resource

@export var passive_name : String = ""
@export_multiline var passive_desc : String = ""

enum Trigger {START_OF_TURN, END_OF_TURN}

var origin : Character
var active : bool = true

func set_passive(_o: Character):
	pass
func deactivate():
	active = false
#TURN
func character_turn(cha : Character):
	start_of_turn(cha)
	if cha.status.can_act:
		action_setup(cha)
	else:
		end_of_turn(cha)

func start_of_turn(cha : Character):
	effect_countdown(1, cha)
	add_crystals(1, cha)

func action_setup(cha : Character):
	cha.action_menu.show()

func end_of_turn(cha : Character):
	Events.end_turn.emit()

#ACTIONS
func skip_action(cha : Character):
	Action.set_action(Action.ActionType.SKIP, Action.Targets.NONE, Action.Restriction.NONE, false)
	add_crystals(1, cha)
	end_of_turn(cha)

func protect_action(cha : Character):
	Action.set_action(Action.ActionType.PROTECT, Action.Targets.NONE, Action.Restriction.NONE, false)
	cha.status_manager.grant_status("protected", cha)
	
	end_of_turn(cha)

func attack_action(cha : Character):
	Action.set_action(Action.ActionType.ATTACK, Action.Targets.ENEMY, Action.Restriction.ALIVE, true)
	cha.action_menu.cancelBtn.show()
	Events.choose_target.emit()

func targeted_action(origin : Character, target : Character):
	match Action.action:
		Action.ActionType.ATTACK:
			GL.attack(origin, target)
		Action.ActionType.ABILITY:
			origin.active.a_ability(origin, target)

#UTILITY
func add_crystals(q : int, cha : Character) -> int:
	if(cha.curr_crystals + q > cha.max_crystals):
		q = cha.archetype.max_crystals - cha.curr_crystals
	cha.set_crystals(cha.curr_crystals + q)
	print(cha.cha_name + " has obtained " + str(q) + (" crystal" if q == 1 else " crystals" ))
	if(cha.curr_crystals == cha.max_crystals):
		pass
		print(cha.cha_name + " has reached its maximum crystals")
	return cha.curr_crystals

func effect_countdown(q : int, cha : Character):
	var d = cha.status.change_duration(-q)
	if(d <= 0):
		cha.status_manager.grant_status("neutral", cha)
	
	var ed : int
	for ef in cha.effect_manager.effect_list:
		ed = ef.change_duration(-q)
		if(ed <= 0):
			cha.effect_manager.delete_effect(ef)

func add_initiative(cha : Character) -> void:
	cha.initiative += 30 - tot_ref(cha)
	Events.initiative_given.emit(cha)

func kill_cha(cha : Character) -> void:
	cha.status_manager.grant_status("dead", cha)

func be_dealt_dmg(cha : Character, dmg : int) -> void:
	cha.lose_health(dmg)
	cha.update_stats()

#STATS
func tot_pow(o : Character) -> int:
	return o.pow + o.status.t_pow + o.effect_manager.t_pow()
func tot_end(o : Character) -> int:
	return o.end + o.status.t_end + o.effect_manager.t_end()
func tot_fin(o : Character) -> int:
	return o.fin + o.status.t_fin + o.effect_manager.t_fin()
func tot_ref(o : Character) -> int:
	return o.ref + o.status.t_ref + o.effect_manager.t_ref()
func tot_vir(o : Character) -> int:
	return o.vir + o.status.t_vir + o.effect_manager.t_vir()
