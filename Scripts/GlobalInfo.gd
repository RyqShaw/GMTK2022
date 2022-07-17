extends Node

const wave_manager = preload("res://Resources/WaveManager.tres")
const player = preload("res://Resources/PlayerStats.tres")

var wave_time : float = 9 setget set_time
var score : int = 0 setget set_score
var difficulty = 1 setget set_difficulty

signal score_changed
signal difficulty_changed
signal time_changed
signal reseting


func set_score(value):
	score = value
	emit_signal("score_changed")

func set_difficulty(value):
	difficulty = value
	emit_signal("difficulty_changed")
	
func set_time(value):
	wave_time = value
	emit_signal("time_changed")

func _ready():
	wave_manager.connect("wave_started", self, "_wave_started")
	wave_manager.connect("break_started", self, "_break_started")

func _wave_started():
	pass
func _break_started():
	wave_time = 9 + (wave_manager.wave_number * 3)

func reset():
	wave_manager.wave_number = 0
	wave_time = 9
	score = 0
	difficulty = 1
	player.health= 6
	player.speed_mod = 3
	player.attack_speedfloat = 3 
	player.damage = 3

	player.planted_count = 3 
	player.inventory = player.none
	player.dice_number= 1
	emit_signal("reseting")
