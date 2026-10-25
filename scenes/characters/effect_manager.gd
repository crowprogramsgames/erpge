class_name EffectManager
extends Node

var effect_list : Array[Effect]

func add_effect(e : Effect):
	effect_list.append(e)

func delete_effect(e : Effect):
	e.queue_free()

func t_pow() -> int:
	var temp : int = 0
	for e in effect_list:
		temp += e.t_pow
	return temp
func t_end() -> int:
	var temp : int = 0
	for e in effect_list:
		temp += e.t_end
	return temp
func t_fin() -> int:
	var temp : int = 0
	for e in effect_list:
		temp += e.t_fin
	return temp
func t_ref() -> int:
	var temp : int = 0
	for e in effect_list:
		temp += e.t_ref
	return temp
func t_vir() -> int:
	var temp : int = 0
	for e in effect_list:
		temp += e.t_vir
	return temp
