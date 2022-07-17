extends Resource
class_name Stats

#health
#export(float) var if you want decimals
#sets health to max health ONLY WHEN game starts
var health = 1 setget set_health

signal no_health
signal health_changed

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <=0:
		emit_signal("no_health")

