class_name StatusManager
extends Manager

const BLESSED : Status = preload("res://statuses/blessed.tres")
const BLINDED : Status = preload("res://statuses/blinded.tres")
const CURSED : Status = preload("res://statuses/cursed.tres")
const DEAD : Status = preload("res://statuses/dead.tres")
const ENRAGED : Status = preload("res://statuses/enraged.tres")
const FOCUSED : Status = preload("res://statuses/focused.tres")
const FRAGILE : Status = preload("res://statuses/fragile.tres")
const FROZEN : Status = preload("res://statuses/frozen.tres")
const HASTED : Status = preload("res://statuses/hasted.tres")
const NEUTRAL : Status = preload("res://statuses/neutral.tres")
const PROTECTED : Status = preload("res://statuses/protected.tres")
const WEAKENED : Status = preload("res://statuses/weakened.tres")

static var status_list : Array[Status] = [
	BLESSED, BLINDED, CURSED, DEAD,
	 ENRAGED, FOCUSED, FRAGILE, FROZEN,
	HASTED, NEUTRAL, PROTECTED, WEAKENED
]
var status : Status

func tot_stat(type : String) -> float:
	match type:
		"pwr":
			return status.t_pow
		"end":
			return status.t_end
		"fin":
			return status.t_fin
		"ref":
			return status.t_ref
		"vir":
			return status.t_vir
		_:
			return 0
func dmg_multiplier(o: Character, t:Character) -> float:
	return status.dmg_multiplier(o,t)
static func find_status(status_n : StringName) -> Status:
	for st in status_list:
		if st.effect_name.capitalize() == status_n.capitalize():
			return st
	return null

static func can_be_granted(status_n : StringName) -> Status:
	return find_status(status_n)

func grant_status(status_n : StringName):
	var found_status = StatusManager.can_be_granted(status_n)
	
	if found_status != null:
		status = found_status.duplicate()
		Events.stat_changes.emit()
func check_status(status_n : StringName) -> bool:
	return status_n.capitalize() == self.status.effect_name.capitalize()
