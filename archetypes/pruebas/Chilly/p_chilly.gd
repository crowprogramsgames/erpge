extends Passive

func set_passive(o: Character):
	Events.initiative_given.connect(_on_initiative_given)
	origin = o

func _on_initiative_given(o: Character):
	if !GL.allies_o_enemies(origin, o) && origin.check_status("dead") :
		o.initiative += 3
	
