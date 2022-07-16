extends Resource
class_name WaveManager

var wave_number = 0
var display = null

enum {
	in_wave,
	in_break
}

var turn setget set_turn

signal wave_started
signal break_started

func set_turn(new_turn):
	turn = new_turn
	match turn:
		in_wave: 
			emit_signal("wave_started")
			wave_number += 1
		in_break: emit_signal("break_started")
