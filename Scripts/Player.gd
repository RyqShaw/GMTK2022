extends KinematicBody2D

export var stats : Resource

var acceleration : float = 450
var friction : float = 400
var max_velocity : float = 75

var velocity : Vector2 = Vector2.ZERO

enum {
	health_seed,
	speed_seed,
	attack_speed_seed,
	damage_seed,
	none
}

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var seed_sprite : Sprite = $Seed
onready var blinkAnimation : AnimationPlayer = $blinkAnimation
onready var hurtbox : Area2D = $Hurtbox

func _ready():
	stats.connect("no_health", self, "death")

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

func _process(_delta):
	match stats.inventory:
		none:
			seed_sprite.visible = false
		health_seed:
			seed_sprite.visible = true
			seed_sprite.frame = 0
		speed_seed:
			seed_sprite.visible = true
			seed_sprite.frame = 3
		attack_speed_seed:
			seed_sprite.visible = true
			seed_sprite.frame = 2
		damage_seed:
			seed_sprite.visible = true
			seed_sprite.frame = 1

func change_animation(vector : Vector2):
	sprite.flip_h = vector.x < 0
	if vector.x != 0:
		sprite.animation = "side_walk"
	elif vector.y >= 0:
		sprite.animation = "down_walk"
	else:
		sprite.animation = "up_walk"


func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
#	knockback = area.knockback_vector * 120
	hurtbox.start_invincibility(0.4)
	blinkAnimation.play("start")

func death():
	queue_free()
