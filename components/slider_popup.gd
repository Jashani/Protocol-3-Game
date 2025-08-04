class_name SliderPopup
extends Control


signal complete


@export var title: Label = null
@export var left_label: Label = null
@export var right_label: Label = null


func set_title(text: String) -> void:
	title.text = text


func set_left_label(text: String) -> void:
	left_label.text = text


func set_right_label(text: String) -> void:
	right_label.text = text


func _on_submit_button_pressed() -> void:
	_save_data()
	complete.emit()
	_close_popup()


func _save_data() -> void:
	pass


func _close_popup() -> void:
	queue_free()
