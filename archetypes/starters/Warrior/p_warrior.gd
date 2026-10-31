extends Passive

@export var hp_threshold : float = 0.5

func _set_triggers():
	Events.attack_hit.connect(_on_attack_hit)

func _on_attack_hit(origin: Character , target: Character):
	if target == source && target.stats.hp <= target.stats.max_hp * hp_threshold :
		target.effect_manager.grant_effect(0,3,0,0,0,3)
	
