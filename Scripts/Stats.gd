extends Resource
class_name Stats

#health
#export(float) var if you want decimals
export var max_health = 1 setget set_max_health
#sets health to max health ONLY WHEN game starts
var health = max_health setget set_health

signal no_health
signal health_changed
signal max_health_changed

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <=0:
		emit_signal("no_health")

func _ready():
	self.health = max_health
