class_name Robot
extends Entity


@export var player_ray: RayCast2D

var is_controlled: bool = false
var _collider = null
var _count: int = 1
var _last_player_direction: Vector2
var _steps_to_move: int = 0

@onready var search_delay: Timer = $SearchDelay


func _ready() -> void:
	EventBus.player_moved.connect(_delay_search)
	search_delay.timeout.connect(_look_for_player)


func _process(_delta: float) -> void:
	if is_controlled:
		super._process(_delta)
		return


# Wait before searching so the robot moves after the player does
func _delay_search() -> void:
	search_delay.start()


func _look_for_player() -> void:
	if is_controlled:
		return
	
	for dir in directions:
		while true:
			player_ray.target_position = directions[dir] * (GRID_SIZE * _count)
			player_ray.force_raycast_update()
			
			_collider = player_ray.get_collider()
			_count += 1
			
			if not _collider:
				continue
				
			if _collider.is_in_group("wall"):
				_count = 1
				break
			
			if _collider.is_in_group("player"):
				_steps_to_move = _count - 2
				_count = 1
				_last_player_direction = directions[dir]
				position += _last_player_direction * GRID_SIZE
				return
	
	if _steps_to_move > 0:
		position += _last_player_direction * GRID_SIZE
		_steps_to_move -= 1
