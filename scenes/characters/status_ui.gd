class_name StatusUI
extends Label

func update_status() -> void:
	var char = get_parent()
	text = "Current status: %s" % char.status.status_name
