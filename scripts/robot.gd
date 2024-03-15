class_name Robot
extends Entity


@export var player_ray: RayCast2D

var is_controlled: bool = false:
	set(value):
		is_controlled = value
		
		if is_controlled:
			_anim_type = 2
		else:
			_anim_type = 1

var _collider = null
var _moving_to_target: bool = false
var _last_player_direction: Vector2
var _anim_type: int = 1

@onready var search_delay: Timer = $SearchDelay
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super._ready()
	
	animation_player.play("down_1")
	collision_with_obstacle.connect(_end_search)
	EventBus.player_moved.connect(_delay_search)
	EventBus.level_reset.connect(reset)
	search_delay.timeout.connect(_look_for_player)


func _process(_delta: float) -> void:
	if is_controlled:
		super._process(_delta)
	
		for dir in directions.keys():
			if Input.is_action_just_pressed(dir):
				animation_player.play(dir + "_2")
	
	if collision_ray.is_colliding():
		var collider := collision_ray.get_collider()
		
		if not is_controlled and collider is Robot:
			animation_player.play("down_1")
			destroy()
			collider.destroy()


func reset() -> void:
	super.reset()
	
	animation_player.play("down_1")
	search_delay.stop()
	_last_player_direction = Vector2.DOWN
	_can_move_boxes = true
	is_controlled = false
	_moving_to_target = false


func destroy() -> void:
	super.destroy()

	EventBus.robot_died.emit()


func take_control() -> void:
	is_controlled = true
	_moving_to_target = false
	_can_move_boxes = true


func release_control() -> void:
	animation_player.play("down_1")
	is_controlled = false
	_can_move_boxes = false


# Wait before searching so the robot moves after the player does
func _delay_search() -> void:
	search_delay.start()


func _end_search() -> void:
	_moving_to_target = false
	_can_move_boxes = true
	_look_for_player()


func _look_for_player() -> void:
	if is_controlled or not _is_active:
		return
	
	if _moving_to_target:
		_move(_last_player_direction)
		var dir_name := _get_dir_name(_last_player_direction)
		
		animation_player.play(dir_name + "_1")
		return
	
	for dir in directions:
		player_ray.target_position = directions[dir] * (GRID_SIZE * 20)
		player_ray.force_raycast_update()
		
		_collider = player_ray.get_collider()
		
		if _collider:
			if _collider.is_in_group("obstacle"):
				continue
			
			if _collider.is_in_group("player"):
				_last_player_direction = directions[dir]
				_move(_last_player_direction)
				animation_player.play(dir + "_1")
				_moving_to_target = true
				_can_move_boxes = false
				return


func _move(dir: Vector2) -> void:
	super._move(dir)
	
	if collision_ray.is_colliding():
		var collider := collision_ray.get_collider()
		
		if not is_controlled and collider.is_in_group("player"):
			collider.destroy()
			EventBus.level_reset.emit()
