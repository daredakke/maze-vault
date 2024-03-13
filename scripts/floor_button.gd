class_name FloorButton
extends Node2D


var is_pressed: bool = false:
	set(value):
		is_pressed = value
		
		if is_pressed:
			sprite.frame = 1
		else:
			sprite.frame = 0

var _wait_time: int = 6
var _wait_count: int = 0
var _delay_check: bool = false
var _was_pressed_last_check: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var pressed_ray: RayCast2D = $PressedRay


func _ready() -> void:
	EventBus.level_reset.connect(reset)
	EventBus.player_moved.connect(_start_check_delay)


func _process(_delta: float) -> void:
	if _delay_check:
		_wait_count += 1
		
		if _wait_count < _wait_time:
			return
		
		_check_if_pressed()
		_wait_count = 0
		_delay_check = false


func reset() -> void:
	is_pressed = false


func _start_check_delay() -> void:
	_delay_check = true


func _check_if_pressed() -> void:
	pressed_ray.force_raycast_update()
	
	if pressed_ray.is_colliding():
		is_pressed = true
		
		if not _was_pressed_last_check:
			EventBus.button_pressed.emit()
			_was_pressed_last_check = true
	else:
		is_pressed = false
		
		if _was_pressed_last_check:
			EventBus.button_released.emit()
			_was_pressed_last_check = false
