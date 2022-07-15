extends KinematicBody2D

export var stats : Resource

var acceleration : float = 450
var friction : float = 400
var max_velocity : float = 75

var velocity : Vector2 = Vector2.ZERO

onready var sprite : AnimatedSprite = $AnimatedSprite

func _physics_process(delta):
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		sprite.playing = true
		velocity = velocity.move_toward(max_velocity * input_vector, acceleration * delta)
	else:
		sprite.playing = false
		sprite.frame = 0
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	change_animation(input_vector)
	velocity = move_and_slide(velocity)

func change_animation(vector : Vector2):
	sprite.flip_h = vector.x < 0
	if vector.x != 0:
		sprite.animation = "side_walk"
	elif vector.y >= 0:
		sprite.animation = "down_walk"
	else:
		sprite.animation = "up_walk"
