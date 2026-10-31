extends Passive

@export var health_loss : int = 6

func _set_modifiers():
	pass
func _set_triggers():
	Events.attack_hit.connect(_on_attack_hit)

func _on_attack_hit(origin : Character, target : Character):
	if GL.allies_o_enemies(target, source) && target.status_manager.check_status("protected"):
		origin.stats.lose_health(health_loss)
