class_name HealthUI
extends Label

func update_hp() -> void:
	var char = get_parent()
	text = "HP: %d/%d" % [char.hp, char.max_hp]
