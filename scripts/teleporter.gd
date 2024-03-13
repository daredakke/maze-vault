class_name Teleporter
extends Node2D


@export var buttons: Array[FloorButton]

var _button_pressed_count: int = 0
var _is_open: bool = false
var _wait_time: int = 6
var _wait_count: int = 0
var _delay_check: bool = false
var _was_active_last_check: bool = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var stood_on_ray: RayCast2D = $StoodOnRay
@onready var check_if_open_delay: Timer = $CheckIfOpenDelay
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	EventBus.level_reset.connect(reset)
	EventBus.player_moved.connect(_start_check_delay)


func _process(_delta: float) -> void:
	if _delay_check:
		_wait_count += 1
		
		if _wait_count < _wait_time:
			return
		
		_check_if_stood_on()
		_wait_count = 0
		_delay_check = false


func reset() -> void:
	_button_pressed_count = 0
	_is_open = false
	animation_player.stop()
	sprite.frame = 0
	_check_if_open_delay_timeout()


func _start_check_delay() -> void:
	if _is_open:
		_delay_check = true


func _check_if_open_delay_timeout() -> void:
	for button in buttons:
		if button.is_pressed:
			_button_pressed_count += 1
	
	if _button_pressed_count == buttons.size():
		_is_open = true
		animation_player.play("active")
		
		if not _was_active_last_check:
			EventBus.teleporter_activated.emit()
			_was_active_last_check = true
	else:
		_is_open = false
		animation_player.stop()
		sprite.frame = 0
		
		if _was_active_last_check:
			EventBus.teleporter_deactivated.emit()
			_was_active_last_check = false
	
	_button_pressed_count = 0


func _check_if_stood_on() -> void:
	stood_on_ray.force_raycast_update()
	
	if not stood_on_ray.is_colliding():
		return
	
	var collider := stood_on_ray.get_collider()
	
	if collider.is_in_group("player"):
		EventBus.player_reached_exit.emit()
