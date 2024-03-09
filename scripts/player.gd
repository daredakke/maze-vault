class_name Player
extends Entity


func _ready() -> void:
	is_controlled = true


func _process(_delta: float) -> void:
	super._process(_delta)

