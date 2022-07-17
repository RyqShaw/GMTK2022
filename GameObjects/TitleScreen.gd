extends Control

signal game_started

func _on_Button_pressed():
	emit_signal("game_started")
	visible = false
