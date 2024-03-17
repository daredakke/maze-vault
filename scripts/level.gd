class_name Level
extends Node2D

# Cutscenes
const END: PackedScene = preload("res://scenes/cutscenes/end.tscn")
const END_FIVE: PackedScene = preload("res://scenes/cutscenes/end_five.tscn")
const END_FOUR: PackedScene = preload("res://scenes/cutscenes/end_four.tscn")
const END_SIX: PackedScene = preload("res://scenes/cutscenes/end_six.tscn")
const END_THREE: PackedScene = preload("res://scenes/cutscenes/end_three.tscn")
const END_TWO: PackedScene = preload("res://scenes/cutscenes/end_two.tscn")
const PITS = preload("res://scenes/cutscenes/pits.tscn")
const FLOOR = preload("res://scenes/cutscenes/floor.tscn")
const FORCEFIELDS = preload("res://scenes/cutscenes/forcefields.tscn")
const INTRO: PackedScene = preload("res://scenes/cutscenes/intro.tscn")
const INTRO_CONTROLS: PackedScene = preload("res://scenes/cutscenes/intro_controls.tscn")
const INTRO_GOAL = preload("res://scenes/cutscenes/intro_goal.tscn")
const INTRO_END = preload("res://scenes/cutscenes/intro_end.tscn")
const ROBOTS = preload("res://scenes/cutscenes/robots.tscn")
const POSSESSOR: PackedScene = preload("res://scenes/cutscenes/possessor.tscn")
const POSSESSOR_TWO: PackedScene = preload("res://scenes/cutscenes/possessor_two.tscn")

# Levels
const LEVEL_TEST: PackedScene = preload("res://scenes/levels/level_test.tscn")
const LEVEL_TEST_2: PackedScene = preload("res://scenes/levels/level_test_2.tscn")
const LEVEL_01: PackedScene = preload("res://scenes/levels/level_01.tscn")
const LEVEL_02: PackedScene = preload("res://scenes/levels/level_02.tscn")
const LEVEL_02b: PackedScene = preload("res://scenes/levels/level_02b.tscn")
const LEVEL_03: PackedScene = preload("res://scenes/levels/level_03.tscn")
const LEVEL_03b: PackedScene = preload("res://scenes/levels/level_03b.tscn")
const LEVEL_04: PackedScene = preload("res://scenes/levels/level_04.tscn")
const LEVEL_04b: PackedScene = preload("res://scenes/levels/level_04b.tscn")
const LEVEL_05: PackedScene = preload("res://scenes/levels/level_05.tscn")
const LEVEL_05b: PackedScene = preload("res://scenes/levels/level_05b.tscn")
const LEVEL_06: PackedScene = preload("res://scenes/levels/level_06.tscn")
const LEVEL_06b: PackedScene = preload("res://scenes/levels/level_06b.tscn")
const LEVEL_07: PackedScene = preload("res://scenes/levels/level_07.tscn")
const LEVEL_08: PackedScene = preload("res://scenes/levels/level_08.tscn")
const LEVEL_09: PackedScene = preload("res://scenes/levels/level_09.tscn")
const LEVEL_10: PackedScene = preload("res://scenes/levels/level_10.tscn")
const LEVEL_11: PackedScene = preload("res://scenes/levels/level_11.tscn")
const LEVEL_12: PackedScene = preload("res://scenes/levels/level_12.tscn")
const LEVEL_13: PackedScene = preload("res://scenes/levels/level_13.tscn")
const LEVEL_14: PackedScene = preload("res://scenes/levels/level_14.tscn")
const LEVEL_15: PackedScene = preload("res://scenes/levels/level_15.tscn")


var _level_scenes: Array = [
	INTRO,
	INTRO_CONTROLS,
	INTRO_GOAL,
	INTRO_END,
	LEVEL_02,
	LEVEL_02b,
	ROBOTS,
	LEVEL_03,
	LEVEL_03b,
	POSSESSOR,
	POSSESSOR_TWO,
	LEVEL_04,
	LEVEL_04b,
	LEVEL_05,
	PITS,
	LEVEL_TEST_2,
	LEVEL_01,
	LEVEL_05b,
	FLOOR,
	LEVEL_06,
	LEVEL_06b,
	LEVEL_08,
	FORCEFIELDS,
	LEVEL_07,
	LEVEL_09,
	LEVEL_10,
	LEVEL_12,
	LEVEL_11,
	LEVEL_15,
	LEVEL_14,
	LEVEL_13,
	END,
	END_TWO,
	END_THREE,
	END_FOUR,
	END_FIVE,
	END_SIX,
]
var _level_instances: Array
var _current_level_index: int = 0
var _current_level_instance: Node


func _ready() -> void:
	for scene in _level_scenes:
		var instance = scene.instantiate() as Node
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
