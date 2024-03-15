class_name Box
extends Area2D


const GRID_SIZE: int = 16

@export var collision_box: CollisionShape2D

var _starting_position: Vector2

@onready var collision_ray: RayCast2D = $CollisionRay
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	EventBus.level_reset.connect(reset)
	animation_player.play("flicker")

	_starting_position = global_position


func reset() -> void:
	global_position = _starting_position
	collision_box.disabled = false
	show()


func destroy() -> void:
	collision_box.disabled = true
	hide()


func move(dir: Vector2) -> bool:
	collision_ray.target_position = dir * GRID_SIZE
	collision_ray.force_raycast_update()

	if not collision_ray.is_colliding():
		position += dir * GRID_SIZE
		EventBus.box_moved.emit()
		return true

	return false
