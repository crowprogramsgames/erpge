class_name Modifier
extends Effect

enum ModType {TEMP, DMG_MULT, DMG, RANGE, SAVE, STATUS, CRYSTAL, ACTION}
enum Affected {SELF, ALLIES, OTHER_ALLIES, ENEMIES, ALL}

@export var mod_type : ModType
@export var affected : Affected

var char_affected : Character

func attach_mod(src : Character):
	source = src
	Events.attach_mod.emit(self, src)
