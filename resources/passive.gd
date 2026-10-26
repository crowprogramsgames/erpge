class_name Passive
extends Resource

@export var passive_name : String = ""
@export_multiline var passive_desc : String = ""

var origin : Character

func set_passive(o: Character):
	pass

#TURN
func character_turn(char : Character):
	start_of_turn(char)
	if char.status.can_act:
		action_setup(char)
	else:
		end_of_turn(char)

func start_of_turn(char : Character):
	effect_countdown(1, char)
	add_crystals(1, char)

func action_setup(char : Character):
	char.action_menu.show()

func end_of_turn(char : Character):
	Events.end_turn.emit()

#ACTIONS
func skip_action(char : Character):
	Action.set_action(Action.ACTION.SKIP, Action.SELECTABLE.NONE, Action.RESTRICTION.NONE)
	add_crystals(1, char)
	end_of_turn(char)

func protect_action(char : Character):
	Action.set_action(Action.ACTION.PROTECT, Action.SELECTABLE.NONE, Action.RESTRICTION.NONE)
	char.status_manager.grant_status("protected", char)
	
	end_of_turn(char)

func attack_action(char : Character):
	Action.set_action(Action.ACTION.ATTACK, Action.SELECTABLE.ENEMY, Action.RESTRICTION.ALIVE)
	char.action_menu.cancelBtn.show()
	Events.choose_target.emit()

func targeted_action(origin : Character, target : Character):
	match Action.action:
		Action.ACTION.ATTACK:
			GL.attack(origin, target)
		Action.ACTION.ABILITY:
			origin.active.a_ability(origin, target)

#UTILITY
func add_crystals(q : int, char : Character) -> int:
	if(char.curr_crystals + q > char.max_crystals):
		q = char.archetype.max_crystals - char.curr_crystals
	char.set_crystals(char.curr_crystals + q)
	print(char.char_name + " has obtained " + str(q) + (" crystal" if q == 1 else " crystals" ))
	if(char.curr_crystals == char.max_crystals):
		pass
		print(char.char_name + " has reached its maximum crystals")
	return char.curr_crystals

func effect_countdown(q : int, char : Character):
	var d = char.status.change_duration(-q)
	if(d <= 0):
		char.status_manager.grant_status("neutral", char)
	
	var ed : int
	for ef in char.effect_manager.effect_list:
		ed = ef.change_duration(-q)
		if(ed <= 0):
			char.effect_manager.delete_effect(ef)

func add_initiative(char : Character) -> void:
	char.initiative += 30 - tot_ref(char)
	Events.initiative_given.emit(char)

func kill_char(char : Character) -> void:
	char.status_manager.grant_status("dead", char)

func be_dealt_dmg(char : Character, dmg : int) -> void:
	char.lose_health(dmg)
	char.update_stats()

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
