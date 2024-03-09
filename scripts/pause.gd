class_name Pause
extends Control


var _music_bus: int = AudioServer.get_bus_index("Music")
var _sfx_bus: int = AudioServer.get_bus_index("SFX")

@onready var new_game_button: Button = %NewGameButton
@onready var settings_button: Button = %SettingsButton
@onready var settings_panel: Panel = %SettingsPanel
@onready var music_value: Label = %MusicValue
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_value: Label = %SFXValue
@onready var sfx_slider: HSlider = %SFXSlider


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and settings_panel.visible:
		_on_close_button_pressed()


func focus_main_menu() -> void:
	new_game_button.grab_focus()


func _on_settings_button_pressed() -> void:
	settings_panel.show()
	music_slider.grab_focus()


func _on_quit_button_pressed() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


func _on_close_button_pressed() -> void:
	settings_panel.hide()
	settings_button.grab_focus()


func _on_music_slider_value_changed(value: float) -> void:
	music_value.text = str(floor(value * 100)) + "%"
	
	_change_volume(_music_bus, value)


func _on_sfx_slider_value_changed(value: float) -> void:
	sfx_value.text = str(floor(value * 100)) + "%"
	
	_change_volume(_sfx_bus, value)


func _on_one_x_check_box_pressed() -> void:
	_resize_screen(Global.Mode.WINDOW_ONE)


func _on_two_x_check_box_pressed() -> void:
	_resize_screen(Global.Mode.WINDOW_TWO)


func _on_fullscreen_check_box_pressed() -> void:
	_resize_screen(Global.Mode.FULLSCREEN)


func _change_volume(bus_index: int, value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	AudioServer.set_bus_mute(bus_index, value < 0.05)


func _resize_screen(mode: int) -> void:
	match mode:
		Global.Mode.WINDOW_ONE, Global.Mode.WINDOW_TWO:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			ProjectSettings.set_setting("display/window/size/borderless", false)
			get_window().size = Global.resolutions[mode]
			get_window().move_to_center()
		
		Global.Mode.FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
