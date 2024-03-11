class_name Forcefield
extends Node2D


var _wait_time: int = 2
var _wait_count: int = 0

@onready var stood_on_ray: RayCast2D = $StoodOnRay
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("flicker")


func _process(_delta: float) -> void:
	_wait_count += 1
	
	if _wait_count >= _wait_time:
		_check_if_stood_on()
		_wait_count = 0


func _check_if_stood_on() -> void:
	stood_on_ray.force_raycast_update()
	
	var collider := stood_on_ray.get_collider()
	
	if collider is Player:
		collider.destroy()
		EventBus.level_reset.emit()
