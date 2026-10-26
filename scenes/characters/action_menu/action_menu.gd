class_name ActionMenu
extends CanvasLayer

@onready var cancelBtn : Button = $CancelButton


func _ready() -> void:
	Action.set_action(Action.ACTION.NONE, Action.SELECTABLE.NONE, Action.RESTRICTION.NONE)

func _on_skip_pressed() -> void:
	Action.set_action(Action.ACTION.SKIP, Action.SELECTABLE.NONE, Action.RESTRICTION.NONE)
	get_parent().passive.skip_action(get_parent())


func _on_protect_button_pressed() -> void:
	Action.set_action(Action.ACTION.PROTECT, Action.SELECTABLE.NONE, Action.RESTRICTION.NONE)

	get_parent().passive.protect_action(get_parent())

func _on_active_button_pressed() -> void:
	var arch : Archetype = get_parent().archetype
	var crystals = get_parent().curr_crystals
	if crystals >= arch.active_ability.cost:
		arch.active_ability.a_action(get_parent())
	else:
		print("not enough crystals (" + str(crystals) + "/" + str(arch.active_ability.cost) + ")")

func _on_attack_button_pressed() -> void:
	#Action.set_action(Action.ACTION.ATTACK, Action.SELECTABLE.ENEMY, Action.RESTRICTION.ALIVE)
	get_parent().passive.attack_action(get_parent())


func _on_cancel_button_pressed() -> void:
	Action.set_action(Action.ACTION.NONE, Action.SELECTABLE.NONE, Action.RESTRICTION.NONE)
	cancelBtn.hide()
	Events.cancel_pressed.emit()
