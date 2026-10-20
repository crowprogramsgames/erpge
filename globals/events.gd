extends Node

#STAT CHANGES
signal stat_changes

#ACTIONS
signal target_selected(target : Character)
signal end_turn
signal choose_target
signal cancel_pressed
#INFORMATION-BLOCK
signal call_info(char : Character)
signal close_info

#EFFECTS & STATUSES
signal delete_effect
signal grant_status(status_n : StringName, target : Character)
signal check_bodies
