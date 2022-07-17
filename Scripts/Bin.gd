extends StaticBody2D

const player = preload("res://Resources/PlayerStats.tres")
const wave_manager = preload("res://Resources/WaveManager.tres")
var in_zone = false

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
onready var exclamation : Sprite = $InZone

func _ready():
	exclamation.visible = false
	player.connect("inventory_changed",self,"status")

func status():
	match player.inventory:
		health_seed:
			exclamation.visible = false
		speed_seed:
			exclamation.visible = false
		attack_speed_seed:
			exclamation.visible = false
		damage_seed:
			exclamation.visible = false
		none:
			exclamation.visible = false
		health_dice:
			exclamation.visible = true
		speed_dice:
			exclamation.visible = true
		attack_speed_dice:
			exclamation.visible = true
		damage_dice:
			exclamation.visible = true

func _on_PlayerDetection_body_entered(_body):
	in_zone = true

func _on_PlayerDetection_body_exited(_body):
	in_zone = false

func _input(event):
	if event.is_action_pressed("interact") and in_zone:
		set_stat()

func set_stat():
	match player.inventory:
		health_dice:
			player.health = player.dice_number +1
			player.inventory = none
		speed_dice:
			player.speed_mod = player.dice_number +1
			player.inventory = none
		attack_speed_dice:
			player.attack_speed = player.dice_number+1
			player.inventory = none
		damage_dice:
			player.damage = player.dice_number+1
			player.inventory = none
