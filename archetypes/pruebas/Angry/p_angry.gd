extends Passive

func _set_triggers():
	Events.attack_hit.connect(_on_attack_hit)

func _set_modifiers():
	pass

func _on_attack_hit(origin: Character , target: Character):
	if target == source:
		target.effect_manager.grant_effect(3,0,0,0,0,3)
	
