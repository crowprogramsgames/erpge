class_name Battle
extends Node2D

@onready var info : Control = $InfoLayer/Info
@onready var background : ColorRect = $Background
@onready var darkBg : ColorRect = $DarkBg

@onready var redTeam = get_tree().get_nodes_in_group("red_team")
@onready var blueTeam = get_tree().get_nodes_in_group("blue_team")
@onready var adventurers = get_tree().get_nodes_in_group("adventurers")

var curr : Character

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_events()
	_set_teams()
	_set_starting_initiative()
	_start_of_game()
	_turn()

func _set_events():
	Events.call_info.connect(_on_call_info)
	Events.close_info.connect(_on_close_info)
	Events.target_selected.connect(_on_target_selected)
	Events.end_turn.connect(_on_end_turn)
	Events.choose_target.connect(_on_choose_target)
	Events.cancel_pressed.connect(_on_cancel_pressed) #BETA
	Events.check_bodies.connect(_on_check_bodies)

func _set_teams():
	for adv in adventurers:
		adv.set_team("red")

func _set_starting_initiative():
	for adv in adventurers:
		adv.set_starting_initiative()

func _start_of_game():
	Events.start_of_game.emit()
func _turn():
	_find_next()
	curr.turn_platform.show()
	curr.character_turn()

#UTIL
func _find_next() -> void:
	for adv in adventurers:
			if curr == null:
				curr = adv
			if adv.initiative < curr.initiative:
				curr = adv

func _is_selectable(origin : Character, target : Character) -> bool:
	var selectable : bool = true
	match Action.selectable:
		Action.SELECTABLE.NONE:
			selectable = false
		Action.SELECTABLE.ALL:
			selectable = true
		Action.SELECTABLE.ENEMY:
			selectable = !GL.allies_o_enemies(curr, target)
		Action.SELECTABLE.ALLY:
			selectable = GL.allies_o_enemies(curr, target)
		Action.SELECTABLE.OTHER:
			selectable = curr != target
		Action.SELECTABLE.OALLY:
			selectable = curr != target && GL.allies_o_enemies(curr, target)
	
	if(selectable):
		match Action.restriction:
			Action.RESTRICTION.ALIVE:
				selectable = !target.check_status("dead")
			Action.RESTRICTION.DEAD:
				selectable = target.check_status("dead")
			Action.RESTRICTION.BOTH:
				selectable = true
			Action.RESTRICTION.ANY:
				selectable = true
			Action.RESTRICTION.NONE:
				selectable = false
	return selectable

#SIGNALS
func _on_call_info(char : Character):
	info.show()
func _on_close_info():
	info.hide()
func _on_end_turn():
	darkBg.hide()
	curr.turn_platform.hide()
	curr.action_menu.cancelBtn.hide()
	curr.passive.add_initiative(curr)
	curr.action_menu.hide()
	_turn()
func _on_choose_target() -> void:
	darkBg.show()
func _on_cancel_pressed() -> void:
	darkBg.hide()
func _on_target_selected(target : Character) -> void:
	if _is_selectable(curr, target):
		curr.passive.targeted_action(curr, target)
func _on_check_bodies():
	var redTeam = get_tree().get_nodes_in_group("red_team")
	var blueTeam = get_tree().get_nodes_in_group("blue_team")
	
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
func _end_game():
	get_tree().quit()
