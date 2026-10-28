class_name HealthUI
extends Label

func update_hp() -> void:
	var cha = get_parent()
	text = "HP: %d/%d" % [cha.hp, cha.max_hp]
