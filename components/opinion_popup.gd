class_name OpinionPopup
extends Control


signal complete(opinion, text)


@export var title: Label = null
@export var input: TextEdit = null
@export var submit_button: Button = null


enum Opinion {SUPPORT, UNSURE, OPPOSE}
var selected_opinion: String # Opinion


func _ready() -> void:
	_disable_submit()
	input.editable = false


func set_title(text: String) -> void:
	title.text = text


func _on_submit_button_pressed() -> void:
	_save_data()
	complete.emit(selected_opinion, input.text)
	_close_popup()


func _save_data() -> void:
	pass


func _close_popup() -> void:
	queue_free()


func _enable_submit() -> void:
	submit_button.disabled = false


func _disable_submit() -> void:
	submit_button.disabled = true


func _enable_text() -> void:
	input.editable = true


func _on_support_button_pressed() -> void:
	_enable_text()
	selected_opinion = "true" # Opinion.SUPPORT


func _on_unsure_button_pressed() -> void:
	_enable_text()
	selected_opinion = "unsure" # Opinion.UNSURE


func _on_oppose_button_pressed() -> void:
	_enable_text()
	selected_opinion = "false" # Opinion.OPPOSE


func _on_response_text_edit_text_changed() -> void:
	if input.text.length() > 0:
		_enable_submit()
	else:
		_disable_submit()
