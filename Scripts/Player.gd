extends KinematicBody2D

const wave_manager = preload("res://Resources/WaveManager.tres")
const bullet = preload("res://GameObjects/Bullet.tscn")
export var stats : Resource
export var BULLET_SPEED = 300

var acceleration : float = 450
var friction : float = 400
var max_velocity : float = 75
var used_velocity : float = max_velocity

signal game_over
var velocity : Vector2 = Vector2.ZERO
var gun_cooldown_enabled = true

enum {
	health_seed,
	speed_seed,
	attack_speed_seed,
	damage_seed,
	none,
	health_dice,
	speed_dice,
	attack_speed_dice,
	damage_dice
}

onready var sprite : AnimatedSprite = $AnimatedSprite
onready var dice : AnimatedSprite = $Dice
onready var seed_sprite : Sprite = $Seed
onready var blinkAnimation : AnimationPlayer = $blinkAnimation
onready var hurtbox : Area2D = $Hurtbox
onready var gun_timer : Timer = $GunCooldown

func _ready():
	gun_timer.wait_time = 0.5
	stats.connect("no_health", self, "death")
	stats.connect("speed_changed", self, "change_movement")
	stats.connect("aspeed_changed", self, "change_attack")
	stats.connect("damage_changed", self, "change_damage")
	GlobalInfo.connect("resetting", self, "reset")

func _physics_process(delta):
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		sprite.playing = true
		velocity = velocity.move_toward(used_velocity * input_vector, acceleration * delta)
	else:
		sprite.playing = false
		sprite.frame = 0
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	change_animation(input_vector)
	velocity = move_and_slide(velocity)
	
	$Gun.rotation = position.angle_to_point(get_global_mouse_position())-deg2rad(180)
	
	if gun_cooldown_enabled == false:
		if Input.is_action_just_pressed("Fire"):
			fire(input_vector)
			gun_cooldown_enabled = true
			gun_timer.start()

func _process(_delta):
	match stats.inventory:
		none:
			seed_sprite.visible = false
			dice.visible = false
		health_seed:
			seed_sprite.visible = true
			dice.visible = false
			seed_sprite.frame = 0
		speed_seed:
			seed_sprite.visible = true
			dice.visible = false
			seed_sprite.frame = 3
		attack_speed_seed:
			seed_sprite.visible = true
			dice.visible = false
			seed_sprite.frame = 2
		damage_seed:
			seed_sprite.visible = true
			dice.visible = false
			seed_sprite.frame = 1
		health_dice:
			seed_sprite.visible = false
			dice.visible = true
			dice.animation = "Red"
			dice.frame = stats.dice_number
		speed_dice:
			seed_sprite.visible = false
			dice.visible = true
			dice.animation = "Yellow"
			dice.frame = stats.dice_number
		attack_speed_dice:
			seed_sprite.visible = false
			dice.visible = true
			dice.animation = "Green"
			dice.frame = stats.dice_number
		damage_dice:
			seed_sprite.visible = false
			dice.visible = true
			dice.animation = "Black"
			dice.frame = stats.dice_number
			

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
	wave_manager.turn = wave_manager.in_break
	emit_signal("game_over")
	visible = false
	gun_cooldown_enabled = true
	

func fire(vector : Vector2):
	var bullet_insatnce = bullet.instance()
	bullet_insatnce.position = $Gun/Spawn.global_position
	bullet_insatnce.rotation_degrees = rad2deg($Gun.global_rotation)
	bullet_insatnce.apply_impulse(Vector2(), Vector2(BULLET_SPEED, 0).rotated($Gun.global_rotation))
	get_tree().get_root().call_deferred("add_child", bullet_insatnce)


func _on_GunCooldown_timeout():
	gun_cooldown_enabled = false

func change_movement():
	if stats.speed_mod == 1:
		used_velocity = max_velocity * 0.5
	elif stats.speed_mod == 2:
		used_velocity = max_velocity * 0.75
	elif stats.speed_mod == 3:
		used_velocity = max_velocity
	elif stats.speed_mod == 4:
		used_velocity = max_velocity * 1.25
	elif stats.speed_mod == 5:
		used_velocity = max_velocity * 1.5
	elif stats.speed_mod == 6:
		used_velocity = max_velocity * 2
func change_attack():
	if stats.attack_speed == 1:
		gun_timer.wait_time = 1.5
	elif stats.attack_speed == 2:
		gun_timer.wait_time = 1
	elif stats.attack_speed == 3:
		gun_timer.wait_time = 0.75
	elif stats.attack_speed == 4:
		gun_timer.wait_time = 0.5
	elif stats.attack_speed == 5:
		gun_timer.wait_time = 0.25
	elif stats.attack_speed == 6:
		gun_timer.wait_time = 0.1

func reset():
	stats.reset()
