class_name Character
extends Node2D

@onready var arrow : Sprite2D = $Arrow
@onready var platform : Sprite2D = $Platform
@onready var action_menu : CanvasLayer = $ActionMenu
@onready var status_manager : StatusManager = $StatusManager
@onready var sprite : Sprite2D = $CharSprite
@onready var turn_platform : Sprite2D = $TurnPlatform
@onready var health_ui : Label = %Health
@onready var status_ui : Label = %Status

const BLUE_PLATFORM = preload("res://art/adv_sprites/blue_platfomr.png")
const RED_PLATFORM = preload("res://art/adv_sprites/red_platform.png")


@export var char_name : StringName = ""
@export var archetype : Archetype :set = _set_archetype

var curr_crystals : int
var effect_list : Array[Effect]
var status : Status

var max_hp : int
var hp : int
var pow : int
var end : int
var fin : int
var ref : int
var vir : int

var weapon : Weapon

var initiative : int = 0

func _ready():
	_set_character()

func _set_character() -> void:
	if not is_inside_tree():
		await ready
	sprite.texture = archetype.portrait
	curr_crystals = archetype.starting_crystals
	status = archetype.starting_status
	
	max_hp = archetype.base_hp
	hp = max_hp
	pow = archetype.base_pow
	end = archetype.base_end
	fin = archetype.base_fin
	ref = archetype.base_ref
	vir = archetype.base_vir
	
	weapon = archetype.weapon
	
	update_stats()
	
func set_team(color) -> void:
	
	if is_in_group("red_team"):
		platform.texture = RED_PLATFORM
	else:
		platform.texture = BLUE_PLATFORM

func _set_archetype(value: Archetype) -> void:
	archetype = value
	_set_character()
	
func set_starting_initiative() -> void:
	initiative = GL.roll20() - tot_ref()
	
func set_crystals(q : int) -> void:
	curr_crystals = q
func set_status(status : Status) -> void:
	self.status = status

func _on_mouse_entered() -> void:
	arrow.show()
	Events.call_info.emit(self)
func _on_mouse_exited() -> void:
	arrow.hide()
	Events.close_info.emit()
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		Events.target_selected.emit(self)
func update_stats() -> void:
	health_ui.update_hp()
	status_ui.update_status()
	Events.check_bodies.emit()
	
	if hp <= 0 and !check_status("dead"):
		_kill_char()
	
#TURN
func character_turn():
	self.archetype.character_turn(self)
	#before action maneuver
	#action
	#after action maneuver
	#end of turn
#STATS
func tot_pow():
	return pow + status.t_pow
func tot_end():
	return end + status.t_end
func tot_fin():
	return fin + status.t_fin
func tot_ref():
	return ref + status.t_ref
func tot_vir():
	return vir + status.t_vir

func check_status(status : StringName):
	return status.capitalize() == self.status.status_name.capitalize()

func _kill_char() -> void:
	status_manager.grant_status("dead", self)
