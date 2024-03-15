class_name ZSkip
extends Node


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		EventBus.player_reached_exit.emit()
