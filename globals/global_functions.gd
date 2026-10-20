extends Node

var rng = RandomNumberGenerator.new()
#@export var status_list = Array[Status]
#UTIL
func roll20():
	return rng.randi()%20+1

#STATUSES



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
		print(origin.char_name + " has dealt " + str(dmg) + " damage to " + target.char_name)
		target.archetype.be_dealt_dmg(target, dmg)
	
	origin.archetype.end_of_turn(origin)
	
func hit(roll: int, origin : Character, target : Character) -> Array[float]:
	var hit_mult : float = 0
	var pre_bonus : int = 0
	if roll <= max(1, -origin.tot_vir()):
		hit_mult = -1
	elif roll >= min(20, 20 - origin.tot_vir()):
		hit_mult = origin.archetype.crit_mult + origin.tot_vir() * origin.archetype.crit_range
	else:
		var attack_roll = roll + origin.tot_fin()
		var dodge = 5 + target.tot_ref()
		var diff = attack_roll - dodge
		if(diff < 0):
			hit_mult = -1
		else:
			hit_mult = 0
			pre_bonus = max(0, diff - 15)
	
	return [hit_mult, pre_bonus]
func damage(pre_b : int, hit_mult : float, o: Character , t : Character) -> int:
	var WD = 4
	var dmg : int = floor(WD * (1 
	+ o.tot_pow() * o.archetype.pow_range 
	+ pre_b * o.archetype.pre_range
	- t.tot_end() * t.archetype.end_range)
	* (1 + hit_mult))
	
	return max(1, dmg)
