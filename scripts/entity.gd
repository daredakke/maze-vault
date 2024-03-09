class_name Entity
extends Area2D


const GRID_SIZE: int = 16

@export var raycast: RayCast2D

var is_controlled: bool = false


func _process(_delta: float) -> void:
	if is_controlled:
		if Input.is_action_just_pressed("right"):
			_move(Vector2.RIGHT)
		elif Input.is_action_just_pressed("down"):
			_move(Vector2.DOWN)
		elif Input.is_action_just_pressed("left"):
			_move(Vector2.LEFT)
		elif Input.is_action_just_pressed("up"):
			_move(Vector2.UP)


func _move(dir: Vector2) -> void:
	raycast.target_position = dir * GRID_SIZE
	raycast.force_raycast_update()
	
	if not raycast.is_colliding():
		position += dir * GRID_SIZE
	else:
		print(raycast.get_collider())
