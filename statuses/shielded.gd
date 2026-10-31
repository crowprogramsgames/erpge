extends Status

func get_attacked() -> bool:
	duration = 0
	Events.stat_changes.emit()
	return false
