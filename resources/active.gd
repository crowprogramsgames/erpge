@abstract class_name Active
extends Resource

@export var active_name : String = ""
@export_multiline var active_desc : String = ""
@export var cost : int = 3

var source : Character

@abstract func a_action() -> void

@abstract func a_ability(t: Character) -> void

func _pay_cost():
	source.stats.curr_crystals -= cost
