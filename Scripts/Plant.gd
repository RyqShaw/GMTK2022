extends Area2D

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
	none
}

var planted = none

onready var sprite : Sprite = $Sprite
onready var exclamation : Sprite = $Selected

func _ready():
	exclamation.visible = false

func _on_Plant_body_entered(body):
	if sprite.frame == 3 or planted == none:
		exclamation.visible = true
		in_zone = true

func _on_Plant_body_exited(body):
	exclamation.visible = false
	in_zone = false

func _input(event):
	if event.is_action_pressed("interact") and in_zone and planted == none:
		planted = inventory.inventory
		inventory.inventory = none
			
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
