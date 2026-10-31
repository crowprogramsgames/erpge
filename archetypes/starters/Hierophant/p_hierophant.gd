extends Passive

func _set_triggers():
	Events.attack_hit.connect(_on_attack_hit)

func _on_attack_hit(origin : Character , target: Character):
	if origin == source:
		source.status_manager.grant_status("shielded")
		Events.stat_changes.emit()
