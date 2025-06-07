extends Control


@export var message_scene: PackedScene
@export var response_text_edit: TextEdit
@export var messages_container: Container
@export var scroll_container: ScrollContainer


func _on_send_button_pressed() -> void:
	_add_message(response_text_edit.text)


func _add_message(text: String) -> void:
	var message = message_scene.instantiate()
	message.set_text(text)
	messages_container.add_child(message)
