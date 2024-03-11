class_name Level
extends Node2D

const LEVEL_TEST: PackedScene = preload("res://scenes/levels/level_test.tscn")
const LEVEL_TEST_2: PackedScene = preload("res://scenes/levels/level_test_2.tscn")
const LEVEL_02: PackedScene = preload("res://scenes/levels/level_02.tscn")
const LEVEL_03: PackedScene = preload("res://scenes/levels/level_03.tscn")
const LEVEL_04: PackedScene = preload("res://scenes/levels/level_04.tscn")
const LEVEL_05: PackedScene = preload("res://scenes/levels/level_05.tscn")


var _level_scenes: Array = [
	LEVEL_02,
	LEVEL_03,
	LEVEL_04,
	LEVEL_05,
	LEVEL_TEST_2,
]
var _level_instances: Array
var _current_level_index: int = 0
var _current_level_instance: Node2D


func _ready() -> void:
	for scene in _level_scenes:
		var instance = scene.instantiate() as Node2D
		_level_instances.append(instance)
	
	# Add first level
	_current_level_instance = _level_instances[_current_level_index]
	add_child(_current_level_instance)
	
	EventBus.player_reached_exit.connect(next_level)


func next_level() -> void:
	_current_level_index += 1
	
	if _current_level_index >= _level_instances.size():
		return
	
	remove_child(_current_level_instance)
	_current_level_instance.queue_free()
	
	_current_level_instance = _level_instances[_current_level_index]
	add_child(_current_level_instance)
