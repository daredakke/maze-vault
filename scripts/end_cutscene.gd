class_name EndCutscene
extends Control


func _ready() -> void:
	EventBus.end_cutscene.emit()


func _on_end_delay_timer_timeout() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
