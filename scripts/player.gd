class_name Player
extends Entity


var _robot_possessed

@onready var shoot_ray: RayCast2D = $ShootRay
@onready var projectile: Line2D = $Projectile
@onready var projectile_reset: Timer = $ProjectileReset
@onready var cooldown: Timer = $Cooldown
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	super._ready()
	EventBus.level_reset.connect(reset)
	
	animation_player.play("down")
	projectile.set_point_position(0, Vector2.ZERO)
	projectile.set_point_position(1, Vector2.ZERO)


func _process(_delta: float) -> void:
	super._process(_delta)
	
	for dir in directions.keys():
		if Input.is_action_just_pressed(dir):
			animation_player.play(dir)
	
	if Input.is_action_just_pressed("action") and cooldown.is_stopped():
		_fire_ray()


func reset() -> void:
	super.reset()
	animation_player.play("down")
	_robot_possessed = null


func destroy() -> void:
	super.destroy()
	
	EventBus.player_died.emit()


func _fire_ray() -> void:
	if _robot_possessed:
		_robot_possessed.animation_player.play("down_1")
		_robot_possessed.release_control()
		_robot_possessed = null
		EventBus.robot_released.emit()
		return
	
	shoot_ray.target_position = _last_direction * (GRID_SIZE * 20)
	shoot_ray.force_raycast_update()
	
	var collider = shoot_ray.get_collider()
	var pos = collider.global_position - global_position
	
	projectile.set_point_position(1, pos)
	cooldown.start()
	projectile_reset.start()
	EventBus.shot_fired.emit()
	
	if collider is Robot:
		collider.take_control()
		_robot_possessed = collider
		_robot_possessed.animation_player.play("down_2")


func _reset_projectile() -> void:
	projectile.set_point_position(1, Vector2.ZERO)
