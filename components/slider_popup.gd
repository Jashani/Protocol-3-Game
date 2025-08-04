class_name SliderPopup
extends Control


signal complete


@export var popup_parent: Control = null


func _on_submit_button_pressed() -> void:
	_save_data()
	complete.emit()
	_close_popup()


func _save_data() -> void:
	pass


func _close_popup() -> void:
	popup_parent.queue_free()
