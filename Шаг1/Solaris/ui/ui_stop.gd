extends Control
var mass_lines:Array
var local_score:int=0
signal restart
signal contin
var str_signal=""
func _ready():
	mass_lines=[$lines/ColorRect,$lines/ColorRect2,$lines/ColorRect3,$lines/ColorRect4,$lines/ColorRect5,
	$lines/ColorRect6,$lines/ColorRect7,$lines/ColorRect8,$lines/ColorRect9,$lines/ColorRect10,
	$lines/ColorRect11,$lines/ColorRect12,$lines/ColorRect13,$lines/ColorRect14,$lines/ColorRect15,
	$lines/ColorRect16,$lines/ColorRect17,$lines/ColorRect18,$lines/ColorRect19,$lines/ColorRect20]

func _on_Timer_timeout():
	for ml in mass_lines:
		ml.color=Color(randf(),randf(),randf(),1)
	$Label.set("custom_colors/font_color",Color(randf(),randf(),randf(),1))


func _on_Timer_score_timeout():
	if local_score<Global.score:
		local_score+=1
		$Label.text="Score:"+str(local_score)
	else:
		$Timer_score.stop()

func _on_continue_button_up():
	str_signal="contin"
	$MarginContainer/VBoxContainer/continue.visible=false
	$MarginContainer/VBoxContainer/restart.visible=false
	$rest.visible=false
	$vid.visible=false
	$MarginContainer/VBoxContainer/play.visible=true
	
func _on_restart_button_up():
	str_signal="restart"
	$MarginContainer/VBoxContainer/continue.visible=false
	$MarginContainer/VBoxContainer/restart.visible=false
	$rest.visible=false
	$vid.visible=false
	$MarginContainer/VBoxContainer/play.visible=true
	
func _on_play_button_up():
	$MarginContainer/VBoxContainer/continue.visible=true
	$MarginContainer/VBoxContainer/restart.visible=true
	$rest.visible=true
	$vid.visible=true
	$MarginContainer/VBoxContainer/play.visible=false
	local_score=0
	emit_signal(str_signal)
