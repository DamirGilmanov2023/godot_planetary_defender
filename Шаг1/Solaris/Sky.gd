extends Node2D
#var player=preload("res://player/player.tscn")
var mass_stars:Array=[]
func _ready():
	mass_stars=[$star1,$star2,$star3,$star4,$star5,$star6,$star7,$star8,$star9,$star10]
	var player=get_tree().get_root().find_node("player",true,false)
	player.connect("damage",self,"dama")
func _process(delta):
	for i in range(len(mass_stars)):
		mass_stars[i].position.y-=1
		if mass_stars[i].position.y<=0:
			mass_stars[i].position.y=316
func dama():
	print("damage")
	$ColorRect.color=Color(1,0.20,0.53,1)
	$planet.visible=false
	$planet_red.visible=true
	$Timer.start()
func _on_Timer_timeout():
	$ColorRect.color=Color(0.07,0,0.56,1)
	$planet.visible=true
	$planet_red.visible=false
