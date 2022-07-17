extends StaticBody2D

const inventory = preload("res://Resources/PlayerStats.tres")
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
var type = none
onready var exclamation : Sprite = $InZone

func _ready():
	exclamation.visible = false
	GlobalInfo.connect("resetting",self,"reset")

func _on_PlayerDetection_body_entered(_body):
	exclamation.visible = true
	in_zone = true

func _on_PlayerDetection_body_exited(_body):
	exclamation.visible = false
	in_zone = false

func _input(event):
	if event.is_action_pressed("interact") and in_zone:
		give_seeds()

func give_seeds():
	if inventory.inventory != health_dice or inventory.inventory != speed_dice or inventory.inventory != attack_speed_dice or inventory.inventory != damage_dice:
		inventory.inventory = type

func reset():
	exclamation.visible = false
	in_zone = false
	type = none
