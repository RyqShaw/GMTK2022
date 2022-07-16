extends Resource
class_name PlayerStats

enum {
	health_seed,
	speed_seed,
	attack_speed_seed,
	damage_seed,
	none
	health_dice,
	speed_dice,
	attack_speed_dice,
	damage_dice
}

const max_health = 6
var health : int = 5 setget set_health
var speed_mod : float = 1
var attack_speed : float = 1
var damage : int = 1

var planted_count = 3 setget set_plant
var inventory = none

signal no_more_plants
signal health_changed
signal no_health

func set_health(value):
	health = value
	emit_signal("health_changed")
	if health <= 0:
		emit_signal("no_health")

func set_plant(value):
	planted_count = value
	if planted_count <= 0:
		emit_signal("no_more_plants")
