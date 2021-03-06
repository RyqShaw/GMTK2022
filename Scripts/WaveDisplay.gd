extends Control

const wave_manager = preload("res://Resources/WaveManager.tres")
const stats = preload("res://Resources/PlayerStats.tres")

onready var wave_label : Label = $WaveNumber
onready var timer_label : Label = $TimerNumber

onready var wave_timer : Timer = $WaveTimer

func _ready():
	wave_timer.wait_time = GlobalInfo.wave_time
	wave_manager.display = self
	wave_manager.connect("wave_started", self, "_wave_started")
	wave_manager.connect("break_started", self, "_break_started")
	GlobalInfo.connect("time_changed",self,"update_time")
	stats.connect("no_more_plants", self, "no_more_to_plant")
	wave_manager.turn = wave_manager.in_break

func _wave_started():
	wave_timer.start()
	wave_timer.wait_time = GlobalInfo.wave_time
	GlobalInfo.difficulty = round(rand_range(1,6))
func _break_started():
	wave_timer.wait_time = GlobalInfo.wave_time

func _process(_delta):
	match wave_manager.turn:
		wave_manager.in_break:
			wave_label.text = "Wave: BREAK"
			timer_label.text = "Time Left: "+ str(GlobalInfo.wave_time)
		wave_manager.in_wave:
			wave_label.text = "Wave: " + str(wave_manager.wave_number)
			timer_label.text = "Time Left: " + str(round(wave_timer.time_left))

func update_time():
	wave_timer.wait_time = GlobalInfo.wave_time

func no_more_to_plant():
	wave_manager.turn = wave_manager.in_wave

func _on_WaveTimer_timeout():
	wave_manager.turn = wave_manager.in_break
