class_name Archetype
extends Resource

@export_group("Archetype Description")
@export var arch_name : String
@export var arch_desc : String
@export var portrait : Texture

@export_group("Base Stats")
@export var stats : Stats

@export_group("Starting Status")
@export var starting_status : Status = preload("res://statuses/neutral.tres") #class status

@export_group("Abilities")
@export var passive_ability : Passive
@export var active_ability : Active

@export_group("Starting Items")
@export var weapon : Weapon = preload("res://items/weapons/unnarmed.tres")
