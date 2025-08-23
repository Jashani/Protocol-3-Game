class_name SliderPopup
extends Control


signal complete


@export var slider: HSlider = null
@export var title: Label = null
@export var left_label: Label = null
@export var right_label: Label = null
@export var data_key: String


func set_title(text: String) -> void:
	title.text = text


func set_left_label(text: String) -> void:
	left_label.text = text


func set_right_label(text: String) -> void:
	right_label.text = text


func set_data_key(key: String) -> void:
	data_key = key


func _on_submit_button_pressed() -> void:
	_save_data()
	complete.emit()
	_close_popup()


func _save_data() -> void:
	Data.save_value(data_key, slider.value)


func _close_popup() -> void:
	queue_free()
