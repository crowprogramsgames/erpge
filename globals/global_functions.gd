extends Node

var rng = RandomNumberGenerator.new()

enum AttackResult {CRIT_MISS, MISS, HIT, CRIT_HIT}

#UTIL
func roll20():
	return rng.randi()%20+1

#ATTACK
func attack(origin : Character, target : Character) -> void:
	var roll = roll20()
	var hit_data : Array[float] = hit(roll, origin, target)
	var hit_mult : float = hit_data[0]
	var pre_bonus : float = hit_data[1]
	
	if hit_mult == -1:
		pass
	else:
		var dmg : int = damage(pre_bonus, hit_mult, origin, target)
		print(origin.cha_name + " has dealt " + str(dmg) + " damage to " + target.cha_name)
		target.passive.be_dealt_dmg(target, dmg)
		if(dmg > 0):
			Events.attack_hit.emit(origin, target)
	
	origin.passive.end_of_turn(origin)
	
func hit(roll: int, origin : Character, target : Character) -> Array[float]:
	var hit_state : AttackResult = AttackResult.HIT
	var hit_mult : float = 0
	var pre_bonus : int = 0
	var attack_roll = roll + origin.passive.tot_fin(origin)
	var dodge = 5 + target.passive.tot_ref(target)
	var diff = attack_roll - dodge
	pre_bonus = max(0, diff - 15)
	
	if roll <= max(1, -origin.passive.tot_vir(origin)):
		hit_mult = -1
		hit_state = AttackResult.CRIT_MISS
	elif roll >= min(20, 20 - origin.passive.tot_vir(origin)):
		hit_mult += origin.archetype.crit_mult + origin.passive.tot_vir(origin) * origin.archetype.crit_range
		hit_state = AttackResult.CRIT_HIT
	elif(diff < 0):
		hit_state = AttackResult.MISS
		hit_mult = -1
	
	if(hit_state == AttackResult.MISS || hit_state == AttackResult.CRIT_MISS):
		Events.attack_missed.emit(origin, target)
	
	return [hit_mult, pre_bonus]

func damage(pre_b : int, hit_mult : float, o: Character , t : Character) -> int:
	var WD : int = o.weapon.weapon_dmg
	var dmg : int = floor(WD * (1 
	+ o.passive.tot_pow(o) * o.archetype.pow_range 
	+ pre_b * o.archetype.pre_range
	- t.passive.tot_end(t) * t.archetype.end_range)
	* (1 + hit_mult))
	
	return max(1, dmg)

func allies_o_enemies(origin : Character, target: Character) -> bool:
	return origin.is_in_group("blue_team") == target.is_in_group("blue_team")
