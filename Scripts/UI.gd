extends Control

const player = preload("res://Resources/PlayerStats.tres")

onready var health : AnimatedSprite = $Dice/Health
onready var speed : AnimatedSprite = $Dice/Speed
onready var aspeed : AnimatedSprite = $Dice/AttackSpeed
onready var damage : AnimatedSprite = $Dice/Damage

func _ready():
	player.connect("health_changed", self, "update_labels")
	player.connect("speed_changed", self, "update_labels")
	player.connect("aspeed_changed", self, "update_labels")
	player.connect("damage_changed", self, "update_labels")
	GlobalInfo.connect("score_changed", self, "update_score")
	GlobalInfo.connect("difficulty_changed", self, "update_difficulty")
	update_labels()
	update_score()
# Called when the node enters the scene tree for the first time.
func update_labels():
	health.frame = player.health-1
	speed.frame = player.speed_mod-1
	aspeed.frame = player.attack_speed-1
	damage.frame = player.damage-1

func update_score():
	$Score.text = "Score " +str(GlobalInfo.score)
func update_difficulty():
	$Dice/Difficulty.frame = GlobalInfo.difficulty - 1
