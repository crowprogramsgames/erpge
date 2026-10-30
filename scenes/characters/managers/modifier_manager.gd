class_name ModifierManager
extends Manager


func add_mod(mod : Modifier, src : Character):
	mod.source = src
	man_list.append(mod)
