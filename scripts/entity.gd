class_name Entity
extends Area2D


signal collision_with_obstacle

const GRID_SIZE: int = 16

@export var is_player: bool = false
@export var collision_box: CollisionShape2D
@export var collision_ray: RayCast2D

var directions: Dictionary = {
	"right": Vector2.RIGHT,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
}

var _is_active: bool = true
var _starting_position: Vector2
var _can_move_boxes: bool = true
var _last_direction := Vector2.DOWN


func _ready() -> void:
	_starting_position = global_position


func _process(_delta: float) -> void:
	if not _is_active:
		return
	
	for dir in directions.keys():
		if Input.is_action_just_pressed(dir):
			if is_player:
				_move(directions[dir])
				_last_direction = directions[dir]
				EventBus.player_moved.emit()
			else:
				call_deferred("_move", directions[dir])


func reset() -> void:
	global_position = _starting_position
	_is_active = true
	collision_box.disabled = false
	show()


func destroy() -> void:
	_is_active = false
	collision_box.disabled = true
	hide()


func _move(dir: Vector2) -> void:
	collision_ray.target_position = dir * GRID_SIZE
	collision_ray.force_raycast_update()
	
	if not collision_ray.is_colliding():
		position += dir * GRID_SIZE
		return
	
	var collider := collision_ray.get_collider()
	
	if _can_move_boxes and collider.is_in_group("moveable"):
		if collider.move(dir):
			position += dir * GRID_SIZE
			return
	
	if collider.is_in_group("obstacle"):
		collision_with_obstacle.emit()


func _get_dir_name(dir: Vector2) -> String:
	if dir == Vector2.UP:
		return "up"
	elif dir == Vector2.RIGHT:
		return "right"
	elif dir == Vector2.LEFT:
		return "left"
	elif dir == Vector2.DOWN:
		return "down"
	else:
		return ""
