extends Node2D
var lines:Array
var speeds:Array=[50,50,50,50]
var i:int=0
var yama:Array
var yama2:Array
var yama_flag:Array=[true,true,true,true]
var yama_flag2:Array=[true,true,true,true]
var sr_position:float
var variant
func _ready():
	lines=[$line0,$line1,$line2,$line3]
	yama=[$Yama2,$Yama3,$Yama4,$Yama5]
	yama2=[$Yama6,$Yama7,$Yama8,$Yama9]
func _process(delta):
	i=0
	while i<len(lines):
		speeds[i]*=1.05
		lines[i].position.y+=delta*speeds[i]
		if lines[i].position.y>660:
			lines[i].position.y=330
			speeds[i]=50
			variant=randi()%2
			if variant==1:
				yama_flag[i]=true
			else:
				yama_flag[i]=false
			variant=randi()%2
			if variant==1:
				yama_flag2[i]=true
			else:
				yama_flag2[i]=false
			if yama_flag[i]:
				yama[i].visible=true
			else:
				yama[i].visible=false
			if yama_flag2[i]:
				yama[i].visible=true
			else:
				yama[i].visible=false
			yama[i].scale.x=0.1
			yama[i].scale.y=0.1
			yama[i].position.x=rand_range(320,350)
			yama2[i].scale.x=0.1
			yama2[i].scale.y=0.1
			yama2[i].position.x=rand_range(620,650)
		if i==len(lines)-1:
			if lines[0].position.y<lines[len(lines)-1].position.y:
				sr_position=lines[len(lines)-1].position.y-(lines[len(lines)-1].position.y-lines[0].position.y)/2
			else:
				sr_position=lines[len(lines)-1].position.y-(lines[len(lines)-1].position.y-330)/2
		else:
			if lines[i+1].position.y<lines[i].position.y:
				sr_position=lines[i].position.y-(lines[i].position.y-lines[i+1].position.y)/2
			else:
				sr_position=lines[i].position.y-(lines[i].position.y-330)/2
		yama[i].position.y=sr_position
		yama2[i].position.y=sr_position
		yama[i].position.x-=2
		yama2[i].position.x+=2
		yama[i].scale.x+=0.01
		yama[i].scale.y+=0.01
		yama2[i].scale.x+=0.01
		yama2[i].scale.y+=0.01
		i+=1
