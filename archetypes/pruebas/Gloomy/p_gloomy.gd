extends Passive

var health_loss = 3

func set_passive(o: Character):
	Events.attack_missed.connect(_on_attack_missed)
	origin = o

func _on_attack_missed(o: Character , t: Character):
	if !GL.allies_o_enemies(origin, o):
		o.lose_health(health_loss)
		o.update_stats()
	
