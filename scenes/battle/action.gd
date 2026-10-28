class_name Action
extends Node

enum ActionType {NONE, ATTACK, ABILITY, PROTECT, SKIP}
enum Targets {NONE, SELF, OALLY, ALLY, ENEMY, OTHER, ALL}
enum Restriction {NONE, ALIVE, DEAD, BOTH, ANY}

static var selectable : bool = false
static var actiontype : ActionType = ActionType.NONE
static var targets : Targets = Targets.NONE
static var restriction : Restriction = Restriction.NONE

static func set_action(act : ActionType, tar : Targets, res : Restriction, sel : bool):
	actiontype = act
	targets = tar
	restriction = res
	selectable = sel
