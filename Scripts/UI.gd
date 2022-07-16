extends Control

const player = preload("res://Resources/PlayerStats.tres")

onready var health : Label = $Labels/Health

func _ready():
	player.connect("health_changed", self, "update_health")
	update_health()
# Called when the node enters the scene tree for the first time.
func update_health():
	health.text = "Health " +str(player.health)
