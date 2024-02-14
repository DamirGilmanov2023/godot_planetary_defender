extends KinematicBody2D
var speed=480
func _process(delta):
	var collision=move_and_collide(Vector2.DOWN*speed*delta)
	if collision:
		var collider=collision.collider
		if collider.has_method("damaged"):
			collider.damaged()
			queue_free()
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
