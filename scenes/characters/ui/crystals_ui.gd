class_name CrystalUI
extends Label

var stats : Stats

func update_crystals() -> void:
	text = "Crystals: %d/%d" % [stats.curr_crystals, stats.max_crystals]
