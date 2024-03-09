class_name Game
extends Node2D


@onready var splash: Splash = %Splash
@onready var pause: Pause = %Pause


func _ready() -> void:
	splash.splash_ended.connect(pause.focus_main_menu)
	pause.game_started.connect(_start_game)
	pause.game_continued.connect(_unpause_game)
	
	pause.load_settings()
	_pause_game()


func _process(_delta: float) -> void:
	if not Global.game_started or Global.game_paused:
		return
	
	if Input.is_action_just_pressed("pause"):
		_pause_game()
		return
	
	if Input.is_action_just_pressed("reset"):
		EventBus.level_reset.emit()
		return


func _start_game() -> void:
	Global.game_started = true
	
	_unpause_game()


func _pause_game() -> void:
	Global.pause_game()
	_handle_pause_state()


func _unpause_game() -> void:
	Global.unpause_game()
	_handle_pause_state()


func _handle_pause_state() -> void:
	if Global.game_paused:
		pause.show()
		
		if Global.game_started:
			pause.focus_main_menu()
	else:
		pause.hide()
