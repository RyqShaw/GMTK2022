extends KinematicBody2D

var acceleration : float = 450
var friction : float = 400
var max_velocity : float = 100

var velocity : Vector2 = Vector2.ZERO

func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(max_velocity * input_vector, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	velocity = move_and_slide(velocity)
