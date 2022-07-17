extends Node2D

export(PackedScene) var mob_scene
const wave_manager = preload("res://Resources/WaveManager.tres")

onready var player = $Player
func _ready():
	randomize()
	wave_manager.connect("wave_started", self, "_wave_started")
	wave_manager.connect("break_started", self, "_break_started")
	GlobalInfo.connect("resetting", self, "reset")
	GlobalInfo.connect("difficulty_changed", self, "difficulty_adjust")

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
	difficulty_adjust()
func _break_started():
	$SpawnTimer.stop()

func difficulty_adjust():
	if GlobalInfo.difficulty == 1:
		$SpawnTimer.wait_time = 1
	elif GlobalInfo.difficulty == 2:
		$SpawnTimer.wait_time = 1
	elif GlobalInfo.difficulty == 3:
		$SpawnTimer.wait_time = 1
	elif GlobalInfo.difficulty == 4:
		$SpawnTimer.wait_time = 1
	elif GlobalInfo.difficulty == 5:
		$SpawnTimer.wait_time = 0.5
	elif GlobalInfo.difficulty == 6:
		$SpawnTimer.wait_time = 0.5

func reset():
	$CanvasLayer/TitleScreen.visible = true
	$CanvasLayer/GameOver.visible = false
	$CanvasLayer/TutorialButton.visible = true
	$YSort/Player.global_position = Vector2(152,72)
	$CanvasLayer/WaveDisplay.visible = false
	$CanvasLayer/UI.visible = false
	$YSort/Player.visible = false
	$YSort/Player.gun_cooldown_enabled = true

func _on_TitleScreen_game_started():
	$Music.play()
	$CanvasLayer/WaveDisplay.visible = true
	$CanvasLayer/UI.visible = true
	$CanvasLayer/TutorialButton.visible = false
	$YSort/Player.visible = true
	$YSort/Player.gun_cooldown_enabled = false


func _on_Player_game_over():
	$Music.stop()
	$CanvasLayer/WaveDisplay.visible = false
	$CanvasLayer/UI.visible = false
	$CanvasLayer/GameOver.visible = true
	$CanvasLayer/GameOver/Timer.start()


func _on_Timer_timeout():
	print("reset")
	get_tree().reload_current_scene()
	GlobalInfo.reset()


func _on_TutorialButton_pressed():
	$CanvasLayer/Tutorial.popup()
	$CanvasLayer/TutorialButton.visible = false
	$CanvasLayer/TitleScreen.visible = false


func _on_Tutorial_popup_hide():
	$CanvasLayer/TutorialButton.visible = true
	$CanvasLayer/TitleScreen.visible = true
