class_name Effect
extends Resource

@export_group("TSTATS")
@export var t_pow : int = 0
@export var t_end : int = 0
@export var t_fin : int = 0
@export var t_ref : int = 0
@export var t_vir : int = 0

@export var duration : int = 2
var source : String = ""

func set_neg_zero() -> void:
	if t_pow < 0:
		_set("t_pow", 0)
	if t_end < 0:
		_set("t_end", 0)
	if t_fin < 0:
		_set("t_fin ", 0)
	if t_ref < 0:
		_set("t_ref", 0)
	if t_vir < 0:
		_set("t_vir", 0)
func set_pos_zero() -> void:
	if t_pow > 0:
		_set("t_pow", 0)
	if t_end > 0:
		_set("t_end", 0)
	if t_fin > 0:
		_set("t_fin ", 0)
	if t_ref > 0:
		_set("t_ref", 0)
	if t_vir > 0:
		_set("t_vir", 0)
func set_source(name : String , ability : String) -> void:
	_set("source", name + ":" + ability)

func change_duration(q : int) -> int:
	_set("duration", duration + q)
	return duration
