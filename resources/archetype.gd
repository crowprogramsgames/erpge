class_name Archetype
extends Resource

@export_group("Archetype Description")
@export var arch_name : String
@export var arch_desc : String
@export var portrait : Texture

@export_group("Base Stats")
@export var base_hp : int = 0 # base maximum hit points
@export var base_pow : int = 0 # base power
@export var base_end : int = 0 # base endurance
@export var base_fin : int = 0 # base finesse
@export var base_ref : int = 0 # base reflexes
@export var base_vir : int = 0 # base virtue

@export_group("Ranges")
@export var pow_range : float = 0.05
@export var end_range : float = 0.05
@export var pre_range : float = 0.05
@export var crit_range : float = 0.05

@export_group("Multipliers")
@export var crit_mult : float = 0.5

@export_group("Crystals")
@export var max_crystals : int = 6
@export var starting_crystals : int = 0

@export_group("Starting Status")
@export var starting_status : Status = preload("res://statuses/neutral.tres") #class status
var effect_list = "empty" #class effect

@export_group("Abilities")
@export var passive_ability : Passive
@export var active_ability : Active

@export_group("Starting Items")
@export var weapon : Weapon = preload("res://items/weapons/unnarmed.tres")
