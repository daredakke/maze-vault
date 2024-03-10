class_name Robot
extends Entity


@export var player_ray: RayCast2D

var is_controlled: bool = false

var _collider = null
var _count: int = 1
var _moving_to_target: bool = false
var _last_player_direction: Vector2

@onready var search_delay: Timer = $SearchDelay


func _ready() -> void:
	super._ready()
	collision_with_obstacle.connect(_end_search)
	EventBus.player_moved.connect(_delay_search)
	search_delay.timeout.connect(_look_for_player)


func _process(_delta: float) -> void:
	if is_controlled:
		super._process(_delta)
		return


func reset() -> void:
	super.reset()
	search_delay.stop()
	_can_move_boxes = true
	is_controlled = false
	_moving_to_target = false

# Wait before searching so the robot moves after the player does
func _delay_search() -> void:
	search_delay.start()


func _end_search() -> void:
	_moving_to_target = false
	_can_move_boxes = true
	_look_for_player()


func _look_for_player() -> void:
	if is_controlled:
		return
	
	if _moving_to_target:
		_move(_last_player_direction)
		return
	
	for dir in directions:
		while true:
			player_ray.target_position = directions[dir] * (GRID_SIZE * _count)
			player_ray.force_raycast_update()
			
			_collider = player_ray.get_collider()
			_count += 1
			
			if _collider and _collider.is_in_group("obstacle"):
				_count = 1
				break
			
			if _collider and _collider.is_in_group("player"):
				_count = 1
				_last_player_direction = directions[dir]
				_move(_last_player_direction)
				_moving_to_target = true
				_can_move_boxes = false
				return
