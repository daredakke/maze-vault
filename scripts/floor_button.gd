class_name FloorButton
extends Node2D


var is_pressed: bool = false

var _wait_time: int = 5
var _wait_count: int = 0
var _delay_check: bool = false

@onready var pressed_ray: RayCast2D = $PressedRay


func _ready() -> void:
	EventBus.player_moved.connect(_start_check_delay)


func _process(_delta: float) -> void:
	if _delay_check:
		_wait_count += 1
		
		if _wait_count < _wait_time:
			return
		
		_check_if_pressed()
		_wait_count = 0
		_delay_check = false


func _start_check_delay() -> void:
	_delay_check = true


func _check_if_pressed() -> void:
	pressed_ray.force_raycast_update()
	
	if pressed_ray.is_colliding():
		is_pressed = true
	else:
		is_pressed = false
