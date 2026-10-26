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
signal check_bodies

#TRIGGERS
signal attack_hit(o: Character, t:Character)
signal start_of_game
signal attack_missed(o: Character, t:Character)
signal initiative_given(o: Character)
