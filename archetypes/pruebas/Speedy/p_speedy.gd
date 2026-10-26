extends Passive

func set_passive(o: Character):
	Events.start_of_game.connect(_on_start_of_game)
	origin = o

func _on_start_of_game():
	origin.status_manager.grant_status("status", origin)
	
