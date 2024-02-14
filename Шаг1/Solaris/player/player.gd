extends KinematicBody2D
signal damage
var velocity=Vector2()
var speed_x=300
var speed_y=120
func _process(delta):
	velocity=Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x-=1
	if Input.is_action_pressed("ui_right"):
		velocity.x+=1
	if Input.is_action_pressed("ui_down"):
		velocity.y+=1
	if Input.is_action_pressed("ui_up"):
		velocity.y-=1
	velocity.x=velocity.x*speed_x
	velocity.y=velocity.y*speed_y
	velocity=move_and_slide(velocity)
func damaged():
	$AudioStreamPlayer.play()
	Global.energy-=1
	emit_signal("damage")
