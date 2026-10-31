class_name Battle
extends Node2D

@onready var info : Control = $InfoLayer/Info
@onready var background : ColorRect = $Background
@onready var darkBg : ColorRect = $DarkBg

static var redTeam : Array[Node]
static var blueTeam : Array[Node]
static var adventurers : Array[Node]

static var curr : Character


func _ready():
	_set_events()
	_set_teams()
	_set_mods()
	_set_starting_initiative()
	_start_of_game()
	_turn()

#START OF GAME
func _set_events():
	#DARKBG
	Events.hide_dark_bg.connect(_on_hide_dark_bg)
	Events.show_dark_bg.connect(_on_show_dark_bg)
	#INFO
	Events.call_info.connect(_on_call_info)
	Events.close_info.connect(_on_close_info)
	#TARGET
	Events.target_selected.connect(_on_target_selected)
	#MODIFIERS
	Events.attach_mod.connect(_on_attach_mod)
	#TURN PHASES
	Events.end_turn.connect(_on_end_turn)
	#CLEANUP
	Events.check_bodies.connect(_on_check_bodies)
func _set_teams():
	_update_teams()
	for adv in adventurers: adv.set_team()
func _set_mods():
	for adv : Character in adventurers:
		adv.passive.set_up_mods()
func _set_starting_initiative():
	for adv : Character in adventurers:
		adv.add_initiative(true)
		
func _start_of_game(): Events.start_of_game.emit()
func _turn():
	curr = _find_next()
	curr.turn_platform.show()
	curr.character_turn()

#TURN
func _find_next() -> Character:
	var current = curr
	for adv in adventurers:
			if current == null:
				current = adv
			if adv.stats.initiative < current.stats.initiative:
				current = adv
	return current
func _can_be_targeted(target : Character) -> bool:
	var selectable : bool = true
	match Action.targets:
		Action.Targets.NONE:
			selectable = false
		Action.Targets.ALL:
			selectable = true
		Action.Targets.ENEMY:
			selectable = !GL.allies_o_enemies(curr, target)
		Action.Targets.ALLY:
			selectable = GL.allies_o_enemies(curr, target)
		Action.Targets.OTHER:
			selectable = curr != target
		Action.Targets.OALLY:
			selectable = curr != target && GL.allies_o_enemies(curr, target)
	
	if(selectable):
		match Action.restriction:
			Action.Restriction.TARGET:
				selectable = target.status_manager.status.can_be_targeted
			Action.Restriction.DEAD:
				selectable = target.status_manager.check_status("dead")
			Action.Restriction.ANY:
				selectable = true
			Action.Restriction.NONE:
				selectable = false
	return selectable

#SIGNALS
func _on_call_info(_cha : Character): info.show()
func _on_close_info(): info.hide()
func _on_end_turn():
	Events.hide_dark_bg.emit()
	curr.turn_platform.hide()
	curr.action_menu.cancelBtn.hide()
	curr.action_menu.hide()
	curr.add_initiative(false)
	_turn()
func _on_target_selected(target : Character) -> void:
	var targets : Array[Character]
	if Action.selectable:
		if _can_be_targeted(target):
			targets.append(target)
			curr.targeted_action(targets)
	else:
		for adv : Character in adventurers:
			if _can_be_targeted(adv):
				targets.append(adv)
		curr.targeted_action(targets)
func _on_check_bodies(): #BETA
	_update_teams()
	
	var redDefeat = true
	var blueDefeat = true
	
	for adv in redTeam:
		if !adv.status_manager.status.defeat:
			redDefeat = false
	for adv in blueTeam:
		if !adv.status_manager.status.defeat:
			blueDefeat = false
	
	if redDefeat || blueDefeat:
		match (int(redDefeat) - int(blueDefeat)):
			1:
				print("blue wins")
			0:
				print("draw")
			-1:
				print("red wins")
		_end_game()
func _end_game(): get_tree().quit()
func _on_attach_mod(mod : Modifier , src : Character):
	print("on attach mod")
	var affected_list : Array[Character] = _get_affected_list(mod , src)
	var new_mod : Modifier 
	for adv in affected_list:
		new_mod = mod.duplicate()
		new_mod.char_affected = adv
		adv.modifier_manager.add_mod(new_mod, adv)
func _on_hide_dark_bg(): darkBg.hide()
func _on_show_dark_bg(): darkBg.show()

#UTILS
func _update_teams():
	redTeam = get_tree().get_nodes_in_group("red_team")
	blueTeam = get_tree().get_nodes_in_group("blue_team")
	adventurers = get_tree().get_nodes_in_group("adventurers")
func _get_affected_list(mod : Modifier, src : Character) -> Array[Character]:
	var affected = mod.affected
	var affected_list : Array[Character] = []
	match affected:
		Modifier.Affected.SELF:
			affected_list.append(src)
		Modifier.Affected.ALLIES:
			for adv in adventurers:
				if GL.allies_o_enemies(src, adv):
					affected_list.append(adv)
		Modifier.Affected.OTHER_ALLIES:
			for adv in adventurers:
				if GL.allies_o_enemies(src, adv) && adv != src:
					affected_list.append(adv)
		Modifier.Affected.ENEMIES:
			for adv in adventurers:
				if !GL.allies_o_enemies(src, adv):
					affected_list.append(adv)
		Modifier.Affected.ALL:
			for adv in adventurers:
				affected_list.append(adv)
	return affected_list
