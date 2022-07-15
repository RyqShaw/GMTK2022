extends Control

const wave_manager = preload("res://Resources/WaveManager.tres")

onready var wave_label : Label = $WaveNumber
onready var timer_label : Label = $TimerNumber

onready var wave_timer : Timer = $WaveTimer
onready var break_timer : Timer = $BreakTimer

func _ready():
	wave_manager.connect("wave_started", self, "_wave_started")
	wave_manager.connect("break_started", self, "_break_started")
	wave_manager.turn = wave_manager.in_break

func _wave_started():
	wave_timer.start()
func _break_started():
	break_timer.start()

func _process(delta):
	match wave_manager.turn:
		wave_manager.in_break:
			wave_label.text = "Wave: BREAK"
			timer_label.text = "Time Left: " + str(round(break_timer.time_left))
		wave_manager.in_wave:
			wave_label.text = "Wave: " + str(wave_manager.wave_number)
			timer_label.text = "Time Left: " + str(round(wave_timer.time_left))


func _on_BreakTimer_timeout():
	wave_manager.turn = wave_manager.in_wave

func _on_WaveTimer_timeout():
	wave_manager.turn = wave_manager.in_break
