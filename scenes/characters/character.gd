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
@onready var crystals_ui : Label = %CrystalsUI
#UI-MENUS
@onready var action_menu : CanvasLayer = $ActionMenu
#MANAGERS
@onready var status_manager : StatusManager = $StatusManager
@onready var effect_manager : EffectManager = $EffectManager
@onready var modifier_manager : ModifierManager = $ModifierManager
#CHARACTER-ISTICS
#Description
@export var char_name : StringName

#Archetype
@export var archetype : Archetype :set = _set_character

var stats : Stats
var passive : Passive
var active : Active
var weapon : Weapon


##FUNCTIONS
func _ready():
	Events.stat_changes.connect(_update_stats)
	action_menu.source = self

#SETTERS
func _set_character(arch : Archetype) -> void:
	if not is_inside_tree():
		await ready
	archetype = arch.duplicate()
	#Ui
	sprite.texture = archetype.portrait
	_set_stats()
	_set_passive()
	_set_active()
	_set_weapon()
	
func _set_active(): 
	active = archetype.active_ability.duplicate()
	active.source = self
func _set_passive():
	passive = archetype.passive_ability.duplicate()
	passive.set_source(self)
func _set_weapon(): weapon = archetype.weapon.duplicate()
func _set_stats():
	stats = archetype.stats.duplicate()
	stats.char_name = char_name
	status_manager.status = archetype.starting_status.duplicate()
	
	health_ui.stats = stats
	crystals_ui.stats = stats
	status_ui.status_manager = status_manager
	
	_update_stats()

func set_team() -> void:
	if is_in_group("red_team"):
		platform.texture = RED_PLATFORM
	else:
		platform.texture = BLUE_PLATFORM

#TURN
func character_turn():
	start_of_turn()
	if status_manager.status.can_act: action_setup()
	else: end_of_turn()
func start_of_turn():
	effect_countdown(stats.cd_per_turn)
	stats.add_crystals(stats.cry_per_turn)
func action_setup(): action_menu.show()
func end_of_turn(): Events.end_turn.emit()

#ACTIONS
func skip_action():
	Action.set_action(Action.ActionType.SKIP, Action.Targets.NONE, Action.Restriction.NONE, false)
	stats.add_crystals(stats.skip_crystals)
	end_of_turn()
func protect_action():
	Action.set_action(Action.ActionType.PROTECT, Action.Targets.NONE, Action.Restriction.NONE, false)
	status_manager.grant_status("protected")
	end_of_turn()
func attack_action():
	Action.set_action(Action.ActionType.ATTACK, Action.Targets.ENEMY, Action.Restriction.TARGET, true)
	action_menu.cancelBtn.show()
	Events.choose_target.emit()
func targeted_action(targets : Array[Character]):
	match Action.actiontype:
		Action.ActionType.ATTACK:
			GL.attack(self, targets)
		Action.ActionType.ABILITY:
			active.a_ability(targets)
	


#GRANT - UPDATE
func _update_stats() -> void:
	health_ui.update_hp()
	status_ui.update_status()
	crystals_ui.update_crystals()
	Events.check_bodies.emit()
	
	if stats.hp <= 0 and !status_manager.check_status("dead"):
		_kill_cha()

#UTILITY
func effect_countdown(q : int):
	var dur = status_manager.status.change_duration(-q)
	if(dur <= 0):
		status_manager.grant_status("neutral")
	
	var effect_duration : int
	for effect in effect_manager.man_list:
		effect_duration = effect.change_duration(-q)
		if(effect_duration <= 0):
			effect_manager.delete_effect(effect)
func _kill_cha() -> void:
	status_manager.grant_status("dead")
func be_dealt_dmg(dmg : int) -> void:
	stats.lose_health(dmg)
func add_initiative(start : bool) -> void:
	var base_ini = 30
	if start:
		base_ini = GL.roll20()
	stats.initiative += base_ini - tot_stat("ref") + tot_stat("ini")
#INPUT-EVENTS
func _on_mouse_entered() -> void:
	arrow.show()
	Events.call_info.emit(self)
func _on_mouse_exited() -> void:
	arrow.hide()
	Events.close_info.emit()
func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		Events.target_selected.emit(self)

#TSTATS
func additional_damage(o: Character, t:Character) -> int:
	return stats.additional_damage(o,t) + status_manager.additional_damage(o,t) + effect_manager.additional_damage(o,t) + modifier_manager.additional_damage(o,t)
func tot_stat(stat : String) -> float:
	return stats.tot_stat(stat) + status_manager.tot_stat(stat)+ effect_manager.tot_stat(stat) + modifier_manager.tot_stat(stat)
func dmg_multiplier(o: Character , t:Character) -> float:
	return stats.dmg_multiplier(o,t) * status_manager.dmg_multiplier(o,t) * effect_manager.dmg_multiplier(o,t) * modifier_manager.dmg_multiplier(o,t)
