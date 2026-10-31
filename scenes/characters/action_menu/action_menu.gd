class_name ActionMenu
extends CanvasLayer

@onready var cancelBtn : Button = $CancelButton

var source : Character

func _ready() -> void:
	Action.set_action(Action.ActionType.NONE, Action.Targets.NONE, Action.Restriction.NONE, false)
	Events.choose_target.connect(_on_choose_target)

#BUTTON PRESSED
func _on_skip_button_pressed() -> void:
	source.skip_action()
func _on_protect_button_pressed() -> void:
	source.protect_action()
func _on_active_button_pressed() -> void:
	
	var crystals = source.stats.curr_crystals
	if crystals >= source.active.cost:
		source.active.a_action()
	else:
		print("not enough crystals (" + str(crystals) + "/" + str(source.active.cost) + ")")
func _on_attack_button_pressed() -> void:
	#Action.set_action(Action.ACTION.ATTACK, Action.SELECTABLE.ENEMY, Action.RESTRICTION.TARGET)
	source.attack_action()
func _on_cancel_button_pressed() -> void:
	Action.set_action(Action.ActionType.NONE, Action.Targets.NONE, Action.Restriction.NONE, false)
	cancelBtn.hide()
	Events.hide_dark_bg.emit()
#OTHER TRIGGERS
func _on_choose_target() -> void:
	Events.show_dark_bg.emit()
