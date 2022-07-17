extends Resource
class_name PlayerStats

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

const max_health = 6
var health : int = 6 setget set_health
var speed_mod : float = 3 setget set_speed
var attack_speed : float = 3 setget set_a_speed
var damage : int = 3 setget set_damage

var planted_count = 3 setget set_plant
var inventory = none setget set_inventory
var dice_number : int = 1

signal no_more_plants
signal health_changed
signal no_health

signal inventory_changed
signal speed_changed
signal aspeed_changed
signal damage_changed
	
	
func set_health(value):
	if value < health:
		GlobalInfo.score += (health - value) *3
	health = value
	if health > 6: health = 6
	emit_signal("health_changed")
	if health <= 0:
		emit_signal("no_health")

func set_plant(value):
	
	planted_count = value
	if planted_count <= 0:
		emit_signal("no_more_plants")
		planted_count = 3

func set_inventory(value):
	inventory = value
	dice_number = round(rand_range(0,5))
	emit_signal("inventory_changed")

func set_speed(value):
	if value < speed_mod:
		GlobalInfo.score += (speed_mod - value) *3
	speed_mod = value
	emit_signal("speed_changed")

func set_a_speed(value):
	if value < attack_speed:
		GlobalInfo.score += (attack_speed - value) *3
	attack_speed = value
	emit_signal("aspeed_changed")

func set_damage(value):
	if value < damage:
		GlobalInfo.score += (damage - value) *3
	damage = value
	emit_signal("damage_changed")
func reset():
	inventory = none
