extends KinematicBody2D
var lor=[-1,1]
var left_or_right=0
var velocity=Vector2()
var speed=180
var death=false
var dead=false
var collision
var collaider
var play:int=0
func _ready():
	randomize()
	left_or_right=lor[randi()%2]
func _physics_process(delta):
	velocity=Vector2()
	if $Raycast_right.is_colliding():
		left_or_right-=1
	if $Raycast_left.is_colliding():
		left_or_right=1
	velocity.x=left_or_right
	velocity.y=1
	velocity=velocity*speed
	if !death:
		collision=move_and_collide(velocity*delta)
		if collision:
			collaider=collision.collider
			if collaider.has_method("damaged"):
				collaider.damaged()
				destroy()
	if global_position.y>=300:
		speed+=12
func destroy():
	death=true
	$Sprite.visible=false
	$AnimatedSprite.visible=true
	$AnimatedSprite.play("death")
	play+=1
	if play==1:
		$AudioStreamPlayer.play()

func _on_AnimatedSprite_animation_finished():
	Global.score+=1
	dead=true
	#queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	dead=true
	#queue_free()
