extends Node2D
var score:int=0
var mass_alive_frags=[]
var energy:int
func functionality(met,value):
	if met=="add":
		mass_alive_frags.append(value)
	elif met=="rem":
		mass_alive_frags.remove(value)
