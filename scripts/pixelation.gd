class_name Pixelation
extends CanvasLayer


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	EventBus.game_started.connect(play)
	EventBus.level_reset.connect(play)
	EventBus.player_reached_exit.connect(play)
	hide()


func play() -> void:
	show()
	animation_player.play("reduce")


func _on_animation_finished(_anim_name: StringName) -> void:
	hide()
