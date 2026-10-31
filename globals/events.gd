extends Node

#DARK BG
signal hide_dark_bg
signal show_dark_bg

#STAT CHANGES
signal stat_changes

#ACTIONS
signal target_selected(target : Character)
signal end_turn
signal choose_target
#INFORMATION-BLOCK
signal call_info(cha : Character)
signal close_info

#EFFECTS-&-STATUSES
signal delete_effect
signal check_bodies

#PASSIVE-MODIFIERS
signal attach_mod(mod : Modifier, src : Character)
signal unattach_mod(mod : Modifier)
signal pause_mod(mod : Modifier)

#PASSIVE-TRIGGERS
#Turn
signal start_of_game

#Attacks
signal attack_hit(o : Character, t : Character)
signal critical_hit(o : Character, t : Character)
signal attack_missed(o : Character, t : Character)
signal critical_miss(o : Character, t : Character)
