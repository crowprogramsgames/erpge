extends Passive

func _set_triggers():
	pass
func _set_modifiers():
	var new_mod : Modifier
	for mod in mod_list:
		new_mod = mod.duplicate()
		new_mod.attach_mod(source)
