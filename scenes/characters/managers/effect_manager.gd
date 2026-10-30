class_name EffectManager
extends Manager

func grant_effect(tpow : int, tend : int, tfin : int, tref : int, tvir : int, dur : int):
	add_effect(Effect.new_effect(tpow,tend,tfin,tref,tvir,dur))
