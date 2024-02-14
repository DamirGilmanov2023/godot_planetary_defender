extends Control
onready var button=$Button
signal start
func _ready():
	pass 

func _on_Button_button_up():
	visible=false
	emit_signal("start")


func _on_Button2_button_up():
	Global.js_auth()
	$Button2.visible=false
