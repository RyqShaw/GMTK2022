extends Area2D

const wave_manager = preload("res://Resources/WaveManager.tres")
const inventory = preload("res://Resources/PlayerStats.tres")
var in_zone = false

const HEALTH_PLANT : Texture = preload("res://Art Assets/RedPlant.png")
const SPEED_PLANT : Texture = preload("res://Art Assets/YellowPlant.png")
const ATTACK_SPEED_PLANT : Texture = preload("res://Art Assets/GreenPlant.png")
const DAMAGE_PLANT : Texture = preload("res://Art Assets/BlackPlant.png")

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

var planted = none

onready var sprite : Sprite = $Sprite
onready var exclamation : Sprite = $Selected

func _ready():
	exclamation.visible = false

func _on_Plant_body_entered(_body):
	if sprite.frame == 3 or planted == none:
		exclamation.visible = true
		in_zone = true

func _on_Plant_body_exited(_body):
	exclamation.visible = false
	in_zone = false

func _input(event):
	if event.is_action_pressed("interact") and in_zone and planted == none:
		planted = inventory.inventory
		inventory.inventory = none
		inventory.planted_count -= 1
		sprite.frame = 0
	elif event.is_action_pressed("interact") and in_zone and planted != none and sprite.frame == 3:
		match planted:
			none:
				pass
			health_seed:
				inventory.inventory = health_dice
				planted = none
			speed_seed:
				inventory.inventory = speed_dice
				planted = none
			attack_speed_seed:
				inventory.inventory = attack_speed_dice
				planted = none
			damage_seed:
				inventory.inventory = damage_dice
				planted = none
			health_dice:
				pass
			speed_dice:
				pass
			attack_speed_dice:
				pass
			damage_dice:
				pass
			
func _process(_delta):
	match planted:
		none:
			sprite.visible = false
		health_seed:
			sprite.visible = true
			sprite.texture = HEALTH_PLANT
		speed_seed:
			sprite.visible = true
			sprite.texture = SPEED_PLANT
		attack_speed_seed:
			sprite.visible = true
			sprite.texture = ATTACK_SPEED_PLANT
		damage_seed:
			sprite.visible = true
			sprite.texture = DAMAGE_PLANT
	
	if wave_manager.turn == wave_manager.in_wave:
		if wave_manager.display.wave_timer.time_left <= (GlobalInfo.wave_time *0.6):
			sprite.frame = 1
		if wave_manager.display.wave_timer.time_left <= (GlobalInfo.wave_time *0.3):
			sprite.frame = 2
	if wave_manager.turn == wave_manager.in_break and sprite.frame == 2:
		sprite.frame = 3
