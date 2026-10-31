class_name Active
extends Resource

enum Save {NONE, PWR, END, FIN, REF, VIR}

@export var active_name : String = ""
@export_multiline var active_desc : String = ""
@export var cost : int = 3

var source : Character
@export_group("Ability Save")
@export var save_difficulty : int = 12
@export var save_stat : Save = Save.NONE

func a_action() -> void:
	pass

func a_ability(targets: Array[Character]) -> void:
	pass

func _pay_cost():
	source.stats.curr_crystals -= cost
func ability_save(target : Character) -> bool:
	return save_difficulty <= GL.roll20() + target.tot_stat(save_st()) + target.tot_stat("save")
func save_st() -> String:
	match save_stat:
		Save.PWR:
			return "pwr"
		Save.END:
			return "end"
		Save.FIN:
			return "fin"
		Save.REF:
			return "ref"
		Save.VIR:
			return "vir"
		_:
			return "none"
