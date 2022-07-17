extends KinematicBody2D


#Variables needed
onready var sprite = $AnimatedSprite
onready var playerDetectionZone = $PlayerDetection
onready var detcollision = $PlayerDetection/CollisionShape2D
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
#onready var animationPlayer = $AnimationPlayer

const wave_manager = preload("res://Resources/WaveManager.tres")

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
export(Resource) var stats 

export var ACCELERATION = 300
export var FRICTION = 200
export var MAX_SPEED = 50
export var WANDER_SPEED_THRESHHOLD = 4

#state machine
enum {
	IDLE
	WANDER
	CHASE
}

var state = CHASE

#const EnemeyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

func _ready():
	difficulty_adjust()
	stats.connect("no_health",self,"_on_Stats_no_health")
	state = pick_random_state([IDLE, WANDER])
	wave_manager.connect("wave_started", self, "_wave_started")
	wave_manager.connect("break_started", self, "_break_started")
	GlobalInfo.connect("difficulty_changed", self, "difficulty_adjust")
	
	
#Knockback/ Being hit calculation
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	#States
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			
			if wanderController.get_time_left() == 0:
				update_wander()
			
			accelerate_towards_point(wanderController.target_positon, delta)
			
			if global_position.distance_to(wanderController.target_positon) <= WANDER_SPEED_THRESHHOLD: 
				update_wander()
			
		CHASE:
			var player = playerDetectionZone.player 
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = WANDER
			seek_player()
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer((rand_range(1,3)))
	
func accelerate_towards_point(position, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(MAX_SPEED* direction, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0
#sets state to chase
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
#	knockback = area.knockback_vector * 120
	hurtbox.start_invincibility(0.4)
	$AnimationPlayer.play("hit")
#	hurtbox.create_hit_effect()

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

#Playing death animation
func _on_Stats_no_health():
	queue_free()
#	var enemyDeathEffect = EnemeyDeathEffect.instance()
#	get_parent().add_child(enemyDeathEffect)
#	enemyDeathEffect.global_position = global_position
#
#func _on_HurtBox_invincibility_started():
#	animationPlayer.play("Start")
#
#func _on_HurtBox_invincibility_ended():
#	animationPlayer.play("Stop")

func _wave_started():
	$FadeAway.play("Visible")
	detcollision.set_deferred("disabled", false)
func _break_started():
	detcollision.set_deferred("disabled", true)
	$FadeAway.play("FadeAway")

func difficulty_adjust():
	if GlobalInfo.difficulty == 1:
		MAX_SPEED = 50
		stats.health = 2
	elif GlobalInfo.difficulty == 2:
		MAX_SPEED = 50
		stats.health = 3
	elif GlobalInfo.difficulty == 3:
		stats.health = 4
		MAX_SPEED = 50
	elif GlobalInfo.difficulty == 4:
		MAX_SPEED = 75
		stats.health = 6
	elif GlobalInfo.difficulty == 5:
		MAX_SPEED = 75
		stats.health = 8
	elif GlobalInfo.difficulty == 6:
		MAX_SPEED = 100
		stats.health = 12
