class_name Status
extends Effect

@export_group("Status Info")
@export var status_name : String = ""
@export var status_desc : String = ""

@export_group("Permissions")
@export var can_act : bool = true
@export var expires: bool = true
@export var can_be_targeted : bool = true
@export var defeat: bool = false

func change_duration(q : int) -> int:
	if expires:
		duration =  duration + q
	return duration
