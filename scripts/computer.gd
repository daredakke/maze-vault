class_name Computer
extends Node2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var end_trigger_ray: RayCast2D = $EndTriggerRay


func _ready() -> void:
	animation_player.play("flicker")


func _process(_delta: float) -> void:
	_check_if_pressed()


func _check_if_pressed() -> void:
	end_trigger_ray.force_raycast_update()
	
	if end_trigger_ray.is_colliding():
		EventBus.player_reached_exit.emit()
