class_name Effect
extends Resource

#enum Trigger {CONSTANT}
#enum Type {STAT, DURATION, CRYSTAL_MAX, HP_MAX, DMG_MULT}

@export_group("Effect Info")
@export var effect_name : String = ""
@export var effect_desc : String = ""

@export_group("Permissions")
@export var can_act : bool = true
@export var can_be_targeted : bool = true
@export var can_expire: bool = true
@export var defeat: bool = false

@export_group("STATS")
@export var t_pow : int = 0
@export var t_end : int = 0
@export var t_fin : int = 0
@export var t_ref : int = 0
@export var t_vir : int = 0
@export var t_ini : int = 0
@export var save_stat: int = 0
@export var duration : int = 3

@export_group("RANGES")
@export var pwr_rng : float = 0
@export var pre_rng : float = 0
@export var cri_rng : float = 0
@export var end_rng : float = 0

@export_group("MULTIPLIERS")
@export var crit_mult : float = 0
@export var dmg_mult : float = 1

var add_dmg : int = 0
var source : Character

#@export_group("Effect Trigger")
#@export var trigger : Trigger = Trigger.CONSTANT
#@export var type : Type
#@export_range(0,5,1) var level : int = 0

static func new_effect(tpow : int , tend : int, tfin : int, tref : int, tvir : int, dur : int) -> Effect:
	var effect : Effect = Effect.new()
	effect.t_pow = tpow
	effect.t_end = tend
	effect.t_fin = tfin
	effect.t_ref = tref
	effect.t_vir = tvir
	effect.duration = dur
	return effect

func set_neg_zero() -> void:
	if t_pow < 0: t_pow = 0
	if t_end < 0: t_end = 0
	if t_fin < 0: t_fin = 0
	if t_ref < 0: t_ref = 0
	if t_vir < 0: t_vir = 0
func set_pos_zero() -> void:
	if t_pow > 0: t_pow = 0
	if t_end > 0: t_end = 0
	if t_fin > 0: t_fin = 0
	if t_ref > 0: t_ref = 0
	if t_vir > 0: t_vir = 0

func change_duration(q : int) -> int:
	if can_expire:
		duration += q
	return duration
func is_empty() -> bool:
	if(t_pow == 0 && t_end == 0 && t_fin == 0 && t_ref == 0 && t_vir == 0):
		return true
	return false

func temp_pow() -> int:
	return t_pow
func temp_end() -> int:
	return t_end
func temp_fin() -> int:
	return t_fin
func temp_ref() -> int:
	return t_ref
func temp_vir() -> int:
	return t_vir
func temp_ini() -> int:
	return t_ini
func pwr_range() -> float:
	return pwr_rng
func pre_range() -> float:
	return pre_rng
func crit_range() -> float:
	return cri_rng
func end_range() -> float:
	return end_rng
func crit_multiplier() -> float:
	return crit_mult
func dmg_multiplier(o:Character, t:Character) -> float:
	return dmg_mult
func additional_damage(o:Character, t:Character) -> int:
	return add_dmg
func save_val() -> float:
	return save_stat
