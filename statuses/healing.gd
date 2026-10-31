extends Status

@export var health_restored : int = 3

func set_up_status():
	Events.start_of_turn.connect(_on_start_of_turn)

func _on_start_of_turn(origin : Character):
	if origin.status_manager.status == self:
		origin.heal(health_restored)
