class_name StatusUI
extends Label

func update_status() -> void:
	var cha = get_parent()
	text = "Current status: %s" % cha.status.status_name
