extends CanvasLayer
const PP=preload("res://pp/pp.tscn")
const FRAG1=preload("res://frag1/frag1.tscn")
const FRAG2=preload("res://frag2/frag2.tscn")
const FRAG3=preload("res://frag3/frag3.tscn")
const PF1=preload("res://pf1/pf1.tscn")
const PF2=preload("res://pf2/pf2.tscn")
const PF3=preload("res://pf3/pf3.tscn")
var flag_fire:bool=true
var frag_fire_flag:bool=false
var frags=[FRAG1,FRAG2,FRAG3]
var mass_pf=[PF1,PF2,PF3]
var flag_frags:bool=false
var i:int
var mass_energy:Array
var flag_game=false
func _ready():
	$Game_timer_one_sec.start()
	$Timer_fire_frag.start()
	Global.energy=10
	mass_energy=[$padder/HBoxContainer/ColorRect,$padder/HBoxContainer/ColorRect2,$padder/HBoxContainer/ColorRect3,
	$padder/HBoxContainer/ColorRect4,$padder/HBoxContainer/ColorRect5,$padder/HBoxContainer/ColorRect6,
	$padder/HBoxContainer/ColorRect7,$padder/HBoxContainer/ColorRect8,$padder/HBoxContainer/ColorRect9,
	$padder/HBoxContainer/ColorRect10]
	$ui_start.connect("start",self,"go_run")
	$ui_stop.connect("contin",self,"contin")
	$ui_stop.connect("restart",self,"restart")
	$AudioGlobal.play()
	$AudioGlobal.volume_db=5
func restart():
	flag_game=true
	$Ground.visible=true
	Global.score=0
	Global.energy=10
	$ui_stop.visible=false
	$AudioGlobal.volume_db=-5
func contin():
	flag_game=true
	$Ground.visible=true
	Global.energy=5
	$ui_stop.visible=false
	$AudioGlobal.volume_db=-5
func go_run():
	flag_game=true
	$TimerStartGround.start()
	$AudioGlobal.volume_db=-5
func _process(delta):
	if flag_game:
		run(delta)
func run(delta):
	if Input.is_action_pressed("fire") and flag_fire:
		flag_fire=false
		var pp=PP.instance()
		pp.global_position=$player.global_position+Vector2(0,-20)
		$AudioPP.play()
		$Enemys.add_child(pp)
		$Timer_fire.start()
	if flag_frags:
		randomize()
		flag_frags=false
		var ident=randi()%3
		var f=frags[ident].instance()
		f.position.x=rand_range(50,950)
		f.position.y=-30
		$Enemys.add_child(f)
		Global.functionality("add",f)
	i=len(Global.mass_alive_frags)-1
	while i>=0:
		if Global.mass_alive_frags[i].dead:
			Global.mass_alive_frags[i].queue_free()
			Global.functionality("rem",i)
		i-=1
	if frag_fire_flag:
		frag_fire_flag=false
		if len(Global.mass_alive_frags)>0:
			randomize()
			var ident_fire_frag=int(rand_range(0,len(Global.mass_alive_frags)-1))
			var pf
			if Global.mass_alive_frags[ident_fire_frag].speed==60:
				pf=mass_pf[0].instance()
			elif Global.mass_alive_frags[ident_fire_frag].speed==120:
				pf=mass_pf[1].instance()
			elif Global.mass_alive_frags[ident_fire_frag].speed==180:
				pf=mass_pf[2].instance()
			if pf!=null and Global.mass_alive_frags[ident_fire_frag].death!=true and Global.mass_alive_frags[ident_fire_frag].position.y<300:
				pf.position.x=int(Global.mass_alive_frags[ident_fire_frag].position.x)
				pf.position.y=int(Global.mass_alive_frags[ident_fire_frag].position.y+20)
				$AudioFireFrag.play()
				$Enemys.add_child(pf)
	$padder/score.text="score-"+str(Global.score)
	i=0
	for i in range(len(mass_energy)):
		if i+1<=Global.energy:
			mass_energy[i].visible=true
		else:
			mass_energy[i].visible=false
	if Global.energy==0:
		$Ground.visible=false
		flag_game=false
		for m in Global.mass_alive_frags:
			m.queue_free()
		Global.mass_alive_frags=[]
		$ui_stop.visible=true
		$ui_stop/Timer_score.start()
		$AudioGlobal.volume_db=-5

func _on_Timer_fire_timeout():
	flag_fire=true

func _on_Game_timer_one_sec_timeout():
	flag_frags=true
	$Game_timer_one_sec.start()

func _on_Timer_fire_frag_timeout():
	if Global.score<10:
		$Timer_fire_frag.wait_time=int(rand_range(60,80))*0.1
	elif Global.score<40:
		$Timer_fire_frag.wait_time=int(rand_range(40,60))*0.08
	elif Global.score<80:
		$Timer_fire_frag.wait_time=int(rand_range(20,40))*0.06
	elif Global.score<100:
		$Timer_fire_frag.wait_time=int(rand_range(10,20))*0.04
	else:
		$Timer_fire_frag.wait_time=int(rand_range(5,10))*0.04
	#$Timer_fire_frag.wait_time=int(rand_range(5,10))*0.04
	frag_fire_flag=true
	print($Timer_fire_frag.wait_time)
	$Timer_fire_frag.start()

func _on_TimerStartGround_timeout():
	$AnimationPlayer.play("fade_in")
	#$Ground.visible=true

func _on_AudioGlobal_finished():
	$AudioGlobal.play()
