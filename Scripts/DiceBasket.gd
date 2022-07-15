extends StaticBody2D

const inventory = preload("res://Resources/PlayerStats.tres")
var in_zone = false

enum {
	health_seed,
	speed_seed,
	attack_speed_seed,
	damage_seed,
	none
}

onready var exclamation : Sprite = $InZone

func _ready():
	exclamation.visible = false

func _on_PlayerDetection_body_entered(body):
	exclamation.visible = true
	in_zone = true

func _on_PlayerDetection_body_exited(body):
	exclamation.visible = false
	in_zone = false

func _input(event):
	if event.is_action_pressed("interact") and in_zone:
		give_seeds()

func give_seeds():
	pass
