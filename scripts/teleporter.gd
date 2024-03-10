class_name Teleporter
extends Node2D


@export var buttons: Array[FloorButton]

var _button_pressed_count: int = 0
var _is_open: bool = false
var _wait_time: int = 5
var _wait_count: int = 0
var _delay_check: bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var stood_on_ray: RayCast2D = $StoodOnRay


func _ready() -> void:
	EventBus.player_moved.connect(_start_check_delay)


func _process(_delta: float) -> void:
	if _delay_check:
		_wait_count += 1
		
		if _wait_count < _wait_time:
			return
		
		_check_if_stood_on()
		_wait_count = 0
		_delay_check = false


func _start_check_delay() -> void:
	if _is_open:
		_delay_check = true


func _check_if_open_delay_timeout() -> void:
	for button in buttons:
		if button.is_pressed:
			_button_pressed_count += 1
	
	if _button_pressed_count == buttons.size():
		sprite_2d.modulate = Color.from_hsv(0.8, 0.76, 0.80, 1.0)
		_is_open = true
	else:
		sprite_2d.modulate = Color.from_hsv(0.8, 0.76, 0.33, 1.0)
		_is_open = false
	
	_button_pressed_count = 0


func _check_if_stood_on() -> void:
	stood_on_ray.force_raycast_update()
	
	if not stood_on_ray.is_colliding():
		return
	
	var collider := stood_on_ray.get_collider()
	
	if collider.is_in_group("player"):
		EventBus.player_reached_exit.emit()
