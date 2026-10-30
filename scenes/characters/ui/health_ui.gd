class_name HealthUI
extends Label

var stats : Stats

func update_hp() -> void:
	text = "HP: %d/%d" % [stats.hp, stats.max_hp]
