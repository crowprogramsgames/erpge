class_name Battle
extends Node2D

#@onready var timer : Timer = $Timer as Timer
@onready var info : Control = $InfoLayer/Info
@onready var background : ColorRect = $Background
@onready var darkBg : ColorRect = $DarkBg

@onready var redTeam = get_tree().get_nodes_in_group("red_team")
@onready var blueTeam = get_tree().get_nodes_in_group("blue_team")
@onready var adventurers = get_tree().get_nodes_in_group("adventurers")

@onready var status_manager := $StatusManager

const N_ADV : int = 3
const N_TEAM : int = 2

@export var curr_character : Character

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_events()
	
	for adv in redTeam:
		adv.set_team("red")
	for adv in blueTeam:
		adv.set_team("blue")
		
	_set_starting_initiative()
	
	_turn()
		

func _turn():
	_find_next()
	curr_character.turn_platform.show()
	curr_character.character_turn()

func _set_events():
	Events.call_info.connect(_on_call_info)
	Events.close_info.connect(_on_close_info)
	Events.target_selected.connect(_on_target_selected)
	Events.end_turn.connect(_on_end_turn)
	Events.choose_target.connect(_on_choose_target)
	Events.cancel_pressed.connect(_on_cancel_pressed)
	Events.check_bodies.connect(_on_check_bodies)

func _set_starting_initiative():
	for adv in adventurers:
		adv.set_starting_initiative()

func _find_next() -> void:
	for adv in adventurers:
			if curr_character == null:
				curr_character = adv
			if adv.initiative < curr_character.initiative:
				curr_character = adv

func _on_call_info(char : Character):
	info.show()
func _on_close_info():
	info.hide()

func _on_end_turn():
	darkBg.hide()
	curr_character.turn_platform.hide()
	curr_character.action_menu.cancelBtn.hide()
	curr_character.archetype.add_initiative(curr_character)
	curr_character.action_menu.hide()
	_turn()

func _on_choose_target() -> void:
	darkBg.show()

func _on_cancel_pressed() -> void:
	darkBg.hide()

func _on_target_selected(target : Character) -> void:
	if is_selectable(curr_character, target):
		curr_character.archetype.targeted_action(curr_character, target)

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
	
func allies_o_enemies(origin : Character, target: Character) -> bool:
	return origin.is_in_group("blue_team") == target.is_in_group("blue_team")
func is_selectable(origin : Character, target : Character) -> bool:
	var selectable : bool = true
	match Action.selectable:
		Action.SELECTABLE.NONE:
			selectable = false
		Action.SELECTABLE.ALL:
			selectable = true
		Action.SELECTABLE.ENEMY:
			selectable = !allies_o_enemies(curr_character, target)
		Action.SELECTABLE.ALLY:
			selectable = allies_o_enemies(curr_character, target)
		Action.SELECTABLE.OTHER:
			selectable = curr_character != target
		Action.SELECTABLE.OALLY:
			selectable = curr_character != target && allies_o_enemies(curr_character, target)
	
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
