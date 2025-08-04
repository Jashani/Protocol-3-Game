extends Control


@export var message_scene: PackedScene
@export var slider_popup_scene: PackedScene

@export var response_text_edit: TextEdit
@export var messages_container: Container
@export var scroll_container: ScrollContainer
@export var title_label: Label

var scenario: Dictionary


func _ready() -> void:
	_setup_scene()
	_create_slider_popup()


func _setup_scene() -> void:
	scenario = Scenarios.get_scenario()
	title_label.text = scenario["title"]


func _on_send_button_pressed() -> void:
	_add_message(response_text_edit.text)


func _add_message(text: String) -> void:
	var message = message_scene.instantiate()
	message.set_text(text)
	messages_container.add_child(message)


func _create_slider_popup() -> void:
	var slider_popup = slider_popup_scene.instantiate()
	add_child(slider_popup)
