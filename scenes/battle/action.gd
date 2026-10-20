class_name Action
extends Node

enum ACTION {NONE, ATTACK, ABILITY, PROTECT, SKIP}
enum SELECTABLE {NONE, SELF, OALLY, ALLY, ENEMY, OTHER, ALL}
enum RESTRICTION {NONE, ALIVE, DEAD, BOTH, ANY}

static var action : ACTION = ACTION.NONE
static var selectable : SELECTABLE = SELECTABLE.NONE
static var restriction : RESTRICTION = RESTRICTION.NONE

static func set_action(act : ACTION, sel : SELECTABLE, res : RESTRICTION):
	action = act
	selectable = sel
	restriction = res
