class_name SliderPopup
extends Control


signal complete


@export var slider: HSlider = null
@export var title: Label = null
@export var left_label: Label = null
@export var right_label: Label = null
@export var value_label: Label = null
@export var data_key: String
@export var min_value: float = 0.0
@export var max_value: float = 100.0
@export var submit_button: Button = null


func from_resource(prompt: Prompt) -> void:
	set_title(prompt.text)
	set_left_label(prompt.left_label)
	set_right_label(prompt.right_label)
	set_data_key(prompt.column_name)
	set_limits(prompt.min_value, prompt.max_value)
	slider.value = prompt.value
	set_value_label(slider.value)


func set_limits(min_limit: float, max_limit: float) -> void:
	slider.min_value = min_limit
	min_value = min_limit
	slider.max_value = max_limit
	max_value = max_limit


func set_title(text: String) -> void:
	title.text = text


func set_left_label(text: String) -> void:
	left_label.text = text


func set_right_label(text: String) -> void:
	right_label.text = text


func set_value_label(value: float) -> void:
	value = clamp(value, min_value, max_value)
	value_label.text = "%0.1f" % value + "%"


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


func _on_slider_value_changed(value: float) -> void:
	set_value_label(value)


func _on_slider_drag_started() -> void:
	submit_button.disabled = false
