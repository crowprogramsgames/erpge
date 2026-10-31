class_name Stats
extends Resource

@export_group("Base Stats")
@export var max_hp : int
@export var hp : int
@export var pwr : int
@export var end : int
@export var fin : int
@export var ref : int
@export var vir : int

var add_dmg : int = 0

@export_group("Hit Multiplier")
@export var hit_mult : float = 0
@export var crit_mult : float = 0.5
@export var dmg_mult : float = 1

@export_group("Ranges")
@export var pwr_range : float = 0.05
@export var pre_range : float = 0.05
@export var end_range : float = 0.05
@export var crit_range : float = 0.05

@export_group("Crystals")
@export var curr_crystals : int = 0
@export var max_crystals : int = 6

var cd_per_turn = 1
var cry_per_turn = 1
var skip_crystals = 1

var char_name
#In-game-stats
var initiative : int = 0

func _update_crystals(q : int) -> void: 
	curr_crystals = q
	if curr_crystals > max_crystals:
		curr_crystals = max_crystals
	Events.stat_changes.emit()
func add_crystals(q : int) -> int:
	if(curr_crystals + q > max_crystals):
		q = max_crystals - curr_crystals
	_update_crystals(curr_crystals + q)
	#print(cha.cha_name + " has obtained " + str(q) + (" crystal" if q == 1 else " crystals" ))
	if(curr_crystals == max_crystals):
		pass
		#print(cha.cha_name + " has reached its maximum crystals")
	return curr_crystals
func tot_stat(type : String) -> float:
	match type:
		"pwr":
			return pwr
		"end":
			return end
		"fin":
			return fin
		"ref":
			return ref
		"vir":
			return vir
		"crit_mult":
			return crit_mult
		"pwr_rng":
			return pwr_range
		"end_rng":
			return end_range
		"cri_rng":
			return crit_range
		"pre_rng":
			return pre_range
		_:
			return 0
func dmg_multiplier(o:Character , t: Character):
	return dmg_mult
func lose_health(quant : int):
	hp -= quant
	Events.stat_changes.emit()
func additional_damage(o:Character, t:Character):
	return add_dmg
