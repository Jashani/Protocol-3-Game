extends Control


@export var popup_parent: Control = null


func _on_submit_button_pressed() -> void:
	_save_data()
	_close_popup()


func _save_data() -> void:
	pass


func _close_popup() -> void:
	popup_parent.queue_free()
