class_name Active
extends Resource

@export var active_name : String = ""
@export_multiline var active_desc : String = ""
@export var cost : int = 3

func a_action(o : Character) -> void:
	pass

func a_ability(o: Character, t: Character) -> void:
	pass

func pay_cost(o : Character):
	o.curr_crystals -= cost
