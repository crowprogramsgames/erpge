extends Passive

var char : Character

func set_passive(o: Character):
	Events.attack_hit.connect(_on_attack_hit)
	char = o

func _on_attack_hit(o: Character , t: Character):
	if t == char:
		t.grant_effect(3,0,0,0,0,3)
	
