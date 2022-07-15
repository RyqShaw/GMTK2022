extends Resource
class_name PlayerStats

enum {
	health_seed,
	speed_seed,
	attack_speed_seed,
	damage_seed,
	none
}

var health : int = 5
var speed_mod : float = 1
var attack_speed : float = 1
var damage : int = 1

var inventory = none
