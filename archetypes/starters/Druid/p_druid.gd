extends Passive

var health_loss : int = 3

func set_passive(o: Character):
	Events.attack_hit.connect(_on_attack_hit)
	origin = o

func _on_attack_hit(o: Character , t: Character):
	if GL.allies_o_enemies(origin, t) && t.check_status("protected"):
		o.lose_health(health_loss)
	
