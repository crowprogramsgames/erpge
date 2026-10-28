class_name StatusManager
extends Node

@export var status_list : Array[Status]

func _ready():
	pass
func _find_status(status_n : StringName) -> Status:
	for status in status_list:
		if status.status_name.capitalize() == status_n.capitalize():
			return status
	return null

func _can_be_granted(status_n : StringName , cha : Character) -> Status:
	return _find_status(status_n)

func grant_status(status_n : StringName, target : Character):
	var found_status = _can_be_granted(status_n, target)
	
	
	
	if found_status != null:
		target.status = found_status.duplicate()
		target.update_stats()
