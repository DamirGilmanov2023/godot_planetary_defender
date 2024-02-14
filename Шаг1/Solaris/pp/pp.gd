extends KinematicBody2D
var speed:int=480
func _process(delta):
	var collision=move_and_collide(Vector2.UP*speed*delta)
	if collision:
		var collaider=collision.collider
		if collaider.has_method("destroy"):
			collaider.destroy()
			queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
