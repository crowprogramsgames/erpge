class_name Archetype
extends Resource

#INFORMATION
@export_group("Archetype Description")
@export var arch_name : String
@export var arch_desc : String
@export var portrait : Texture

#STATS
@export_group("Base Stats")
@export var base_hp : int = 0 # base maximum hit points
@export var base_pow : int = 0 # base power
@export var base_end : int = 0 # base endurance
@export var base_fin : int = 0 # base finesse
@export var base_ref : int = 0 # base reflexes
@export var base_vir : int = 0 # base virtue

#RANGES
@export_group("Ranges")
@export var pow_range : float = 0.05
@export var end_range : float = 0.05
@export var pre_range : float = 0.05
@export var crit_range : float = 0.05

#MULTIPLIERS
@export_group("Multipliers")
@export var crit_mult : float = 0.5
#CRYSTALS
@export_group("Crystals")
@export var max_crystals : int = 6
@export var starting_crystals : int = 0


#EFFECTS
@export_group("Starting Status")
@export var starting_status : Status = preload("res://statuses/neutral.tres") #class status
var effect_list = "empty" #class effect


#ABILITIES
@export_group("Abilities")
@export var passive_ability : Passive
@export var active_ability : Active


#TURN
func character_turn(char : Character):
	start_of_turn(char)
	if char.status.can_act:
		action_setup(char)
	else:
		end_of_turn(char)

func start_of_turn(char : Character):
	effect_countdown(1, char)
	add_crystals(1, char)

func action_setup(char : Character):
	char.action_menu.show()

func end_of_turn(char : Character):
	Events.end_turn.emit()
#ACTIONS
func skip_action(char : Character):
	Action.set_action(Action.ACTION.SKIP, Action.SELECTABLE.NONE, Action.RESTRICTION.NONE)
	add_crystals(1, char)
	end_of_turn(char)

func protect_action(char : Character):
	Action.set_action(Action.ACTION.PROTECT, Action.SELECTABLE.NONE, Action.RESTRICTION.NONE)
	char.status_manager.grant_status("protected", char)
	
	end_of_turn(char)

func attack_action(char : Character):
	Action.set_action(Action.ACTION.ATTACK, Action.SELECTABLE.ENEMY, Action.RESTRICTION.ALIVE)
	char.action_menu.cancelBtn.show()
	Events.choose_target.emit()

func targeted_action(origin : Character, target : Character):
	match Action.action:
		Action.ACTION.ATTACK:
			GL.attack(origin, target)
		_:
			pass

#UTILITY
func add_crystals(q : int, char : Character) -> int:
	if(char.curr_crystals + q > max_crystals):
		q = char.archetype.max_crystals - char.curr_crystals
	char.set_crystals(char.curr_crystals + q)
	#print(char.char_name + " has obtained " + str(q) + (" crystal" if q == 1 else " crystals" ))
	if(char.curr_crystals == char.archetype.max_crystals):
		pass
		#print(char.char_name + " has reached its maximum crystals")
	return char.curr_crystals

func effect_countdown(q : int, char : Character):
	var d = char.status.change_duration(-q)
	if(d <= 0):
		char.status_manager.grant_status("neutral", char)

func add_initiative(char : Character) -> void:
	char.initiative += 30 - char.tot_ref()

func kill_char(char : Character) -> void:
	char.status_manager.grant_status("dead", char)

func be_dealt_dmg(char : Character, dmg : int) -> void:
	char.hp -= dmg
	char.update_stats()
