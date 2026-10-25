extends Passive

func set_passive(o: Character):
	Events.attack_hit.connect(_on_attack_hit)
	origin = o

func _on_attack_hit(o: Character , t: Character):
	if o == origin:
		o.grant_effect(0,0,3,0,0,3)
	
