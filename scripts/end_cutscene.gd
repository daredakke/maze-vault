class_name EndCutscene
extends Control


func _on_end_delay_timer_timeout() -> void:
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()
