class_name Message

extends HBoxContainer

@export var response_label: Label


func set_text(text: String) -> void:
	response_label.text = text
