extends Control
onready var button=$Button
signal start
func _ready():
	pass 

func _on_Button_button_up():
	visible=false
	emit_signal("start")
