class_name Game
extends Node2D


@onready var splash: Splash = %Splash
@onready var pause: Pause = %Pause


func _ready() -> void:
	splash.splash_ended.connect(pause.focus_main_menu)
	
	_pause_game()


func _pause_game() -> void:
	Global.pause_game()
	_handle_pause_state()


func _unpause_game() -> void:
	Global.unpause_game()
	_handle_pause_state()


func _handle_pause_state() -> void:
	if Global.game_paused:
		#pause.show()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_VISIBLE)
	else:
		#pause.hide()
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
