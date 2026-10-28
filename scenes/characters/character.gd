class_name Character
extends Node2D

#UI
const BLUE_PLATFORM = preload("res://art/adv_sprites/blue_platfomr.png")
const RED_PLATFORM = preload("res://art/adv_sprites/red_platform.png")
@onready var arrow : Sprite2D = $Arrow
@onready var platform : Sprite2D = $Platform
@onready var sprite : Sprite2D = $CharSprite
@onready var turn_platform : Sprite2D = $TurnPlatform
@onready var health_ui : Label = %Health
@onready var status_ui : Label = %Status
#UI-MENUS
@onready var action_menu : CanvasLayer = $ActionMenu
#MANAGERS
@onready var status_manager : StatusManager = $StatusManager
@onready var effect_manager : EffectManager = $EffectManager

#CHARACTER-ISTICS
#Description
@export var cha_name : StringName

#Archetype
@export var archetype : Archetype :set = _set_character

var passive : Passive
var active : Active
var weapon : Weapon
var status : Status
var effect_list : Array[Effect]

#Crystals
var curr_crystals : int
var max_crystals : int

#Stats
var max_hp : int
var hp : int
var pow : int
var end : int
var fin : int
var ref : int
var vir : int

#In-game-stats
var initiative : int = 0

##FUNCTIONS
#SETTERS
func _set_character(arch : Archetype) -> void:
	if not is_inside_tree():
		await ready
	archetype = arch.duplicate()
	#Ui
	sprite.texture = archetype.portrait
	
	_set_passive()
	_set_active()
	_set_weapon()
	_set_stats()
	
	update_stats()

func _set_active(): active = archetype.active_ability.duplicate()
func _set_passive():
	passive = archetype.passive_ability.duplicate()
	passive.set_passive(self)
func _set_weapon(): weapon = archetype.weapon.duplicate()
func _set_stats():
	curr_crystals = archetype.starting_crystals
	max_crystals = archetype.max_crystals
	max_hp = archetype.base_hp
	hp = max_hp
	pow = archetype.base_pow
	end = archetype.base_end
	fin = archetype.base_fin
	ref = archetype.base_ref
	vir = archetype.base_vir
	status = archetype.starting_status.duplicate()


func set_team() -> void:
	if is_in_group("red_team"):
		platform.texture = RED_PLATFORM
	else:
		platform.texture = BLUE_PLATFORM
func set_starting_initiative() -> void:
	initiative = GL.roll20() - passive.tot_ref(self)


#GRANT - UPDATE
func grant_effect(tpow : int, tend : int, tfin : int, tref : int, tvir : int, dur : int):
	effect_manager.add_effect(Effect.new_effect(tpow,tend,tfin,tref,tvir,dur))
func update_crystals(q : int) -> void: curr_crystals = q
func update_status() -> void: self.status = archetype.starting_status.duplicate()
func update_stats() -> void:
	health_ui.update_hp()
	status_ui.update_status()
	Events.check_bodies.emit()
	
	if hp <= 0 and !check_status("dead"):
		_kill_cha()


#INPUT-EVENTS
func _on_mouse_entered() -> void:
	arrow.show()
	Events.call_info.emit(self)
func _on_mouse_exited() -> void:
	arrow.hide()
	Events.close_info.emit()
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		Events.target_selected.emit(self)

	
#TURN
func character_turn():
	self.passive.character_turn(self)
	#before action maneuver
	#action
	#after action maneuver
	#end of turn

#UTILITY
func lose_health(quant : int): hp -= quant
func check_status(status : StringName) -> bool: return status.capitalize() == self.status.status_name.capitalize()

func _kill_cha() -> void:
	status_manager.grant_status("dead", self)
	passive.deactivate()
