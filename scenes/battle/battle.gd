class_name Battle
extends Node2D

@onready var info : Control = $InfoLayer/Info
@onready var background : ColorRect = $Background
@onready var darkBg : ColorRect = $DarkBg

@onready var redTeam : Array[Node]
@onready var blueTeam : Array[Node]
@onready var adventurers : Array[Node]

var curr : Character


func _ready():
	_set_events()
	_set_teams()
	_set_starting_initiative()
	_start_of_game()
	_turn()

#START OF GAME

func _set_events():
	#INFO
	Events.call_info.connect(_on_call_info)
	Events.close_info.connect(_on_close_info)
	#TARGET
	Events.target_selected.connect(_on_target_selected)
	Events.choose_target.connect(_on_choose_target)
	#ACTIONS
	Events.cancel_pressed.connect(_on_cancel_pressed)
	#TURN PHASES
	Events.end_turn.connect(_on_end_turn)
	#CLEANUP
	Events.check_bodies.connect(_on_check_bodies)
func _set_teams():
	_update_teams()
	for adv in adventurers: adv.set_team()
func _set_starting_initiative(): for adv in adventurers: adv.set_starting_initiative()
func _start_of_game(): Events.start_of_game.emit()
func _turn():
	curr = _find_next()
	curr.turn_platform.show()
	curr.character_turn()

#TURN
func _find_next() -> Character:
	var current : Character
	for adv in adventurers:
			if current == null:
				current = adv
			if adv.initiative < current.initiative:
				current = adv
	return current

func _can_be_targeted(origin : Character, target : Character) -> bool:
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
			Action.Restriction.ALIVE:
				selectable = !target.check_status("dead")
			Action.Restriction.DEAD:
				selectable = target.check_status("dead")
			Action.Restriction.BOTH:
				selectable = true
			Action.Restriction.ANY:
				selectable = true
			Action.Restriction.NONE:
				selectable = false
	return selectable

#SIGNALS
func _on_call_info(cha : Character): info.show()
func _on_close_info(): info.hide()
func _on_end_turn():
	darkBg.hide()
	curr.turn_platform.hide()
	curr.action_menu.cancelBtn.hide()
	curr.passive.add_initiative(curr)
	curr.action_menu.hide()
	_turn()
func _on_choose_target() -> void: darkBg.show() #BETA : CHANGE TO CHARACTER
func _on_cancel_pressed() -> void: darkBg.hide() #BETA : CHANGE TO CHARACTER
func _on_target_selected(target : Character) -> void: if _can_be_targeted(curr, target): curr.passive.targeted_action(curr, target) #CHANGE TO CHARACTER
func _on_check_bodies(): #BETA
	_update_teams()
	
	var redDefeat = true
	var blueDefeat = true
	
	for adv in redTeam:
		if !adv.status.defeat:
			redDefeat = false
	for adv in blueTeam:
		if !adv.status.defeat:
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

#UTILS
func _update_teams():
	redTeam = get_tree().get_nodes_in_group("red_team")
	blueTeam = get_tree().get_nodes_in_group("blue_team")
	adventurers = get_tree().get_nodes_in_group("adventurers")
