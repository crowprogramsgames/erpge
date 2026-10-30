@abstract class_name Passive
extends Resource

@export var passive_name : String = ""
@export_multiline var passive_desc : String = ""

@export var mod_list : Array[Modifier]

var source : Character
var active : bool = false


func set_source(src : Character):
	source = src
func set_up_mods():
	_set_modifiers()
	_set_triggers()
@abstract func _set_modifiers()
@abstract func _set_triggers()
