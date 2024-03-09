class_name Entity
extends Area2D


const GRID_SIZE: int = 16

@export var is_player: bool = false
@export var collision_ray: RayCast2D

var directions: Dictionary = {
	"right": Vector2.RIGHT,
	"down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
}


func _process(_delta: float) -> void:
	for dir in directions.keys():
		if Input.is_action_just_pressed(dir):
			if is_player:
				_move(directions[dir])
				EventBus.player_moved.emit()
			else:
				call_deferred("_move", directions[dir])


func _move(dir: Vector2) -> void:
	collision_ray.target_position = dir * GRID_SIZE
	collision_ray.force_raycast_update()
	
	if not collision_ray.is_colliding():
		position += dir * GRID_SIZE
	else:
		print_debug(collision_ray.get_collider())
