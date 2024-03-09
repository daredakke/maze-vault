class_name Box
extends Area2D


const GRID_SIZE: int = 16

@onready var collision_ray: RayCast2D = $CollisionRay


func move(dir: Vector2) -> bool:
	collision_ray.target_position = dir * GRID_SIZE
	collision_ray.force_raycast_update()
	
	if not collision_ray.is_colliding():
		position += dir * GRID_SIZE
		return true
	
	return false
