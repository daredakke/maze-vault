class_name Void
extends Node2D


@export var is_one_step_tile: bool = false

var _wait_time: int = 5
var _wait_count: int = 0
var _delay_check: bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stood_on_ray: RayCast2D = $StoodOnRay


func _ready() -> void:
	EventBus.level_reset.connect(reset)
	EventBus.player_moved.connect(_start_check_delay)
	
	if is_one_step_tile:
		sprite_2d.frame = 1


func _process(_delta: float) -> void:
	if _delay_check:
		_wait_count += 1
		
		if _wait_count < _wait_time:
			return
		
		_check_if_stood_on()
		_wait_count = 0
		_delay_check = false


func reset() -> void:
	if is_one_step_tile:
		sprite_2d.frame = 1


func _start_check_delay() -> void:
	_delay_check = true


func _check_if_stood_on() -> void:
	stood_on_ray.force_raycast_update()
	
	if not stood_on_ray.is_colliding():
		return
	
	var collider := stood_on_ray.get_collider()
	
	if collider is Entity:
		if sprite_2d.frame == 1:
			sprite_2d.frame = 0
			print("BREAK")
		else:
			print("DED")
