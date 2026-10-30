class_name ActionMenu
extends CanvasLayer

@onready var cancelBtn : Button = $CancelButton

func _ready() -> void:
	Action.set_action(Action.ActionType.NONE, Action.Targets.NONE, Action.Restriction.NONE, false)
	Events.choose_target.connect(_on_choose_target)

#BUTTON PRESSED
func _on_skip_button_pressed() -> void:
	get_parent().skip_action()
func _on_protect_button_pressed() -> void:
	get_parent().protect_action()
func _on_active_button_pressed() -> void:
	var cha = get_parent()
	var crystals = cha.stats.curr_crystals
	if crystals >= cha.active.cost:
		cha.active.active_ability.a_action(get_parent())
	else:
		print("not enough crystals (" + str(crystals) + "/" + str(cha.active_ability.cost) + ")")
func _on_attack_button_pressed() -> void:
	#Action.set_action(Action.ACTION.ATTACK, Action.SELECTABLE.ENEMY, Action.RESTRICTION.ALIVE)
	get_parent().attack_action()
func _on_cancel_button_pressed() -> void:
	Action.set_action(Action.ActionType.NONE, Action.Targets.NONE, Action.Restriction.NONE, false)
	cancelBtn.hide()
	Events.hide_dark_bg.emit()
#OTHER TRIGGERS
func _on_choose_target() -> void:
	Events.show_dark_bg.emit()
