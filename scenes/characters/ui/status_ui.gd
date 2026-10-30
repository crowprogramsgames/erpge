class_name StatusUI
extends Label

var status_manager : StatusManager

func update_status() -> void:
	text = "Current status: %s" % status_manager.status.effect_name
