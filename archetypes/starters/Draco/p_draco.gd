extends Passive

func _set_triggers():
	Events.start_of_game.connect(_on_start_of_game)

func _on_start_of_game():
	for adv : Character in Battle.adventurers:
		if !GL.allies_o_enemies(adv, source):
			adv.effect_manager.grant_effect(0,-3,0,0,0,3)
