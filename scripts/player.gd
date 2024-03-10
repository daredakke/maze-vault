class_name Player
extends Entity


var _robot_possessed: Robot

@onready var shoot_ray: RayCast2D = $ShootRay
@onready var projectile: Line2D = $Projectile
@onready var projectile_reset: Timer = $ProjectileReset


func _ready() -> void:
	super._ready()
	
	projectile.set_point_position(0, Vector2.ZERO)
	projectile.set_point_position(1, Vector2.ZERO)


func _process(_delta: float) -> void:
	super._process(_delta)
	
	if Input.is_action_just_pressed("action"):
		_fire_ray()


func _fire_ray() -> void:
	if _robot_possessed:
		_robot_possessed.release_control()
	
	shoot_ray.target_position = _last_direction * (GRID_SIZE * 20)
	shoot_ray.force_raycast_update()
	
	var collider = shoot_ray.get_collider()
	var pos = collider.global_position - global_position
	
	projectile.set_point_position(1, pos)
	projectile_reset.start()
	
	if collider is Robot:
		collider.take_control()
		_robot_possessed = collider


func _reset_projectile() -> void:
	projectile.set_point_position(1, Vector2.ZERO)
