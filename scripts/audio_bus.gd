class_name AudioBus
extends Node


@onready var player_death_sfx: AudioStreamPlayer = $PlayerDeathSFX
@onready var robot_death_sfx: AudioStreamPlayer = $RobotDeathSFX
@onready var box_move_sfx: AudioStreamPlayer = $BoxMoveSFX
@onready var menu_hover_sfx: AudioStreamPlayer = $MenuHoverSFX
@onready var menu_select_sfx: AudioStreamPlayer = $MenuSelectSFX
@onready var level_reset_sfx: AudioStreamPlayer = $LevelResetSFX
@onready var teleporter_activate_sfx: AudioStreamPlayer = $TeleporterActivateSFX
@onready var teleporter_deactivate_sfx: AudioStreamPlayer = $TeleporterDeactivateSFX
@onready var teleport_sfx: AudioStreamPlayer = $TeleportSFX
@onready var shot_fired_sfx: AudioStreamPlayer = $ShotFiredSFX
@onready var robot_released_sfx: AudioStreamPlayer = $RobotReleasedSFX
@onready var button_pressed_sfx: AudioStreamPlayer = $ButtonPressedSFX
@onready var button_released_sfx: AudioStreamPlayer = $ButtonReleasedSFX


func _ready() -> void:
	EventBus.level_reset.connect(play_level_reset)
	EventBus.player_reached_exit.connect(play_teleported)
	EventBus.player_died.connect(play_player_death)
	EventBus.robot_died.connect(play_robot_death)
	EventBus.box_moved.connect(play_box_move)
	EventBus.button_pressed.connect(play_button_pressed)
	EventBus.button_released.connect(play_button_released)
	EventBus.teleporter_activated.connect(play_teleporter_activated)
	EventBus.teleporter_deactivated.connect(play_teleporter_deactivated)
	EventBus.shot_fired.connect(play_shot_fired)
	EventBus.robot_released.connect(play_robot_released)


func play_menu_selected() -> void:
	menu_select_sfx.play()


func play_menu_hovered() -> void:
	if not menu_select_sfx.playing and not menu_hover_sfx.playing:
		menu_hover_sfx.play()


func play_player_death() -> void:
	player_death_sfx.play()


func play_robot_death() -> void:
	robot_death_sfx.play()


func play_box_move() -> void:
	box_move_sfx.play()


func play_level_reset() -> void:
	level_reset_sfx.play()


func play_teleporter_activated() -> void:
	teleporter_activate_sfx.play()


func play_teleporter_deactivated() -> void:
	teleporter_deactivate_sfx.play()


func play_teleported() -> void:
	teleport_sfx.play()


func play_shot_fired() -> void:
	shot_fired_sfx.play()


func play_robot_released() -> void:
	robot_released_sfx.play()


func play_button_pressed() -> void:
	button_pressed_sfx.play()


func play_button_released() -> void:
	button_released_sfx.play()


func _on_player_death_sfx_finished() -> void:
	_modulate_pitch(player_death_sfx)


func _on_robot_death_sfx_finished() -> void:
	_modulate_pitch(robot_death_sfx)


func _on_shot_fired_sfx_finished() -> void:
	_modulate_pitch(shot_fired_sfx)


func _on_robot_released_sfx_finished() -> void:
	_modulate_pitch(robot_released_sfx)


func _on_box_move_sfx_finished() -> void:
	_modulate_pitch(box_move_sfx)


func _modulate_pitch(audio_player: AudioStreamPlayer) -> void:
	audio_player.pitch_scale = randf_range(0.93, 1.07)
