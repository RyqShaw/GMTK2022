extends Node2D

export(PackedScene) var mob_scene
const wave_manager = preload("res://Resources/WaveManager.tres")

func _ready():
	randomize()
	wave_manager.connect("wave_started", self, "_wave_started")
	wave_manager.connect("break_started", self, "_break_started")

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("EnemyPath/EnemyPathSpawn")
	mob_spawn_location.offset = randi()

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _wave_started():
	$SpawnTimer.start()
func _break_started():
	$SpawnTimer.stop()
