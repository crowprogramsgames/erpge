extends Passive

func _set_triggers():
	Events.start_of_game.connect(_on_start_of_game)

func _set_modifiers():
	pass

func _on_start_of_game():
	source.status_manager.grant_status("hasted")
	
