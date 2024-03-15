class_name Game
extends Node2D

@onready var audio_bus: Node = $AudioBus
@onready var splash: Splash = %Splash
@onready var pause: Pause = %Pause
@onready var level: Level = %Level


func _enter_tree() -> void:
	get_tree().node_added.connect(_connect_button_sfx)


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


func _connect_button_sfx(node: Node) -> void:
	if node is Button:
		node.focus_entered.connect(_menu_hovered)
		node.mouse_entered.connect(_menu_hovered)
		node.pressed.connect(_menu_selected)

	if node is HSlider:
		node.focus_entered.connect(_menu_hovered)
		node.mouse_entered.connect(_menu_hovered)

	if node.is_in_group("sfx_slider"):
		node.drag_ended.connect(_sfx_slider_drag_ended)


func _start_game() -> void:
	Global.game_started = true
	EventBus.game_started.emit()

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


func _menu_hovered() -> void:
	audio_bus.play_menu_hovered()


func _menu_selected() -> void:
	audio_bus.play_menu_selected()


func _sfx_slider_drag_ended(_value_changed: float) -> void:
	audio_bus.play_menu_selected()

