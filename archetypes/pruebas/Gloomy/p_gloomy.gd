extends Passive

@export var health_loss = 3

func _set_triggers():
	Events.attack_missed.connect(_on_attack_missed)

func _set_modifiers():
	pass

func _on_attack_missed(origin: Character , target: Character):
	if GL.allies_o_enemies(target, source):
		origin.stats.lose_health(health_loss)
	
