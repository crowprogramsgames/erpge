extends Node

var rng = RandomNumberGenerator.new()
var base_dodge = 5

enum AttackResult {CRIT_MISS, MISS, HIT, CRIT_HIT}

#UTIL
func roll20():
	return rng.randi()%20+1

#ATTACK
func attack(origin : Character, targets : Array[Character]) -> void:
	var roll = roll20()
	var hit_data : Array[float]
	var hit_mult : float
	var pre_bonus : float 
	
	for target in targets:
		hit_data  = hit(roll, origin, target)
		hit_mult = hit_data[0]
		pre_bonus = hit_data[1]
		
		if hit_mult == -1:
			pass
		else:
			var dmg : int = atk_damage(pre_bonus, hit_mult, origin, target)
			print(origin.stats.char_name + " has dealt " + str(dmg) + " damage to " + target.stats.char_name)
			target.be_dealt_dmg(dmg)
			if(dmg > 0):
				Events.attack_hit.emit(origin, target)
		
	origin.end_of_turn()
	
func hit(roll: int, origin : Character, target : Character) -> Array[float]:
	var hit_state : AttackResult = AttackResult.HIT
	var hit_mult : float = 0
	var pre_bonus : int = 0
	var attack_roll = roll + origin.tot_stat("fin")
	var dodge = base_dodge + target.tot_stat("ref")
	var diff = attack_roll - dodge
	pre_bonus = max(0, diff - 15)
	
	
	
	if roll <= max(1, -origin.tot_stat("vir")):
		hit_mult = -1
		hit_state = AttackResult.CRIT_MISS
	elif roll >= min(20, 20 - origin.tot_stat("vir")):
		hit_mult += origin.tot_stat("crit_mult") + origin.tot_stat("vir") * origin.tot_stat("cri_rng") 
		hit_state = AttackResult.CRIT_HIT
	elif(diff < 0):
		hit_state = AttackResult.MISS
		hit_mult = -1
	
	if(hit_state == AttackResult.MISS || hit_state == AttackResult.CRIT_MISS):
		Events.attack_missed.emit(origin, target)
	
	return [hit_mult, pre_bonus]

func atk_damage(pre_b : int, hit_mult : float, o: Character , t : Character) -> int:
	var WD : int = o.weapon.weapon_dmg + o.additional_damage(o,t)
	var dmg : int = int(floor(WD * (1 + o.tot_stat("pwr") * o.tot_stat("pwr_rng") + pre_b * o.tot_stat("pre_rng") - t.tot_stat("end") * t.tot_stat("end_rng")) * (1 + hit_mult) * (dmg_multiplier(o,t))))

	return max(1, dmg)

func dmg_multiplier(o : Character,t : Character) -> float:
	return o.dmg_multiplier(o,t) * t.dmg_multiplier(o,t)

func allies_o_enemies(origin : Character, target: Character) -> bool:
	return origin.is_in_group("blue_team") == target.is_in_group("blue_team")
