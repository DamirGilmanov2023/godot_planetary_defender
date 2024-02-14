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
var mode="pause"
var auth_num=0
var flag_auth:bool
func _ready():
	$Game_timer_one_sec.start()
	$Timer_fire_frag.start()
	
	mass_energy=[$padder/HBoxContainer/ColorRect,$padder/HBoxContainer/ColorRect2,$padder/HBoxContainer/ColorRect3,
	$padder/HBoxContainer/ColorRect4,$padder/HBoxContainer/ColorRect5,$padder/HBoxContainer/ColorRect6,
	$padder/HBoxContainer/ColorRect7,$padder/HBoxContainer/ColorRect8,$padder/HBoxContainer/ColorRect9,
	$padder/HBoxContainer/ColorRect10]
	$ui_start.connect("start",self,"go_run")
	$ui_stop.connect("contin",self,"contin")
	$ui_stop.connect("restart",self,"restart")
	$AudioGlobal.volume_db=5
	
	
	Global.connect('is_auth',self,'_is_auth')
	Global.js_is_auth()
	Global.connect('get_lider',self,'_get_lider')
	
	Global.js_foc_unfoc()
	Global.connect('foc_unfoc',self,'_foc_unfoc')
	
	Global.connect('get_data',self,'_get_data')
	Global.js_get_data()
	Global.js_show_ad()

func _get_data(value):
	Global.energy=10
	Global.score=0
	if value!="Null":
		var v1:int
		var v2:int
		var v=value.split("_")
		v1=int(v[0])
		v2=int(v[1])
		if v2>0 and v1!=0:
			Global.score=v1
			Global.energy=v2
			$padder/score.text="очки-"+str(Global.score)
			for i in range(len(mass_energy)):
				if i+1<=Global.energy:
					mass_energy[i].visible=true
				else:
					mass_energy[i].visible=false
	

func _foc_unfoc(value):
	if value=="foc" and flag_game==true:
		#mode="pause"
		#$pause.texture_normal=load("res://ui/pause.png")
		#get_tree().paused=false
		#Global.mute=false
		pass
	elif value=="unfoc" and flag_game==true:
		mode="play"
		$pause.texture_normal=load("res://ui/play.png")
		get_tree().paused=true
		#$AudioGlobal
	elif value=="unfoc" and flag_game==false:
		$AudioGlobal.stream_paused=true
		Global.mute=true
	#elif value=="foc" and flag_game==false:
	#	$AudioGlobal.stream_paused=false
	#	Global.mute=false

func _get_lider(value):
	if value<Global.score:
		Global.js_set_score_lider('8bit',Global.score)
		$ui_stop/Label2.text="рекорд:"+str(Global.score)
	else:
		$ui_stop/Label2.text="рекорд:"+str(value)

func _is_auth(value):
	if value==false:
		if auth_num==0:
			$ui_start/Button2.visible=true
			auth_num+=1
		flag_auth=false
	else:
		flag_auth=true
	local_auth()
	
func local_auth():
	if flag_auth:
		Global.js_get_score_lider('8bit')
	else:
		if Global.global_score<Global.score:
			Global.global_score=Global.score
		$ui_stop/Label2.text="рекорд:"+str(Global.global_score)

func restart():
	flag_game=true
	$Ground.visible=true
	Global.score=0
	Global.js_set_data("0_10")
	print(Global.score)
	Global.energy=10
	$ui_stop.visible=false
	$AudioGlobal.volume_db=-5
func contin():
	flag_game=true
	$Ground.visible=true
	Global.energy=5
	Global.js_set_data(str(Global.score)+"_5")
	$ui_stop.visible=false
	$AudioGlobal.volume_db=-5
func go_run():
	Global.mute=false
	$AudioGlobal.play()
	flag_game=true
	$TimerStartGround.start()
	$AudioGlobal.volume_db=-5
	
func _process(delta):
	if flag_game:
		run(delta)
	if Global.mute:
		$AudioGlobal.stream_paused=true
	else:
		$AudioGlobal.stream_paused=false
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
	$padder/score.text="очки-"+str(Global.score)
	i=0
	for i in range(len(mass_energy)):
		if i+1<=Global.energy:
			mass_energy[i].visible=true
		else:
			mass_energy[i].visible=false
	if Global.energy<1:
		Global.js_get_score_lider('8bit')
	if Global.energy<=0:
		Global.js_is_auth()
		$Ground.visible=false
		flag_game=false
		for m in Global.mass_alive_frags:
			m.queue_free()
		Global.mass_alive_frags=[]
		$ui_stop.visible=true
		$ui_stop/Timer_score.start()
		$AudioGlobal.volume_db=-5
		$AudioGlobal.stream_paused=true
		Global.mute=true
		#Global.js_is_auth()
		

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
	$Timer_fire_frag.start()

func _on_TimerStartGround_timeout():
	$AnimationPlayer.play("fade_in")
	#$Ground.visible=true

func _on_AudioGlobal_finished():
	$AudioGlobal.play()

func _on_pause_button_up():
	if mode=="pause":
		$pause.texture_normal= load("res://ui/play.png")
		mode="play"
		get_tree().paused=true
		Global.mute=true
	elif mode=="play":
		$pause.texture_normal=load("res://ui/pause.png")
		mode="pause"
		get_tree().paused=false
		Global.mute=false
