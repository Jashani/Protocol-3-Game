extends Control


@export var message_scene: PackedScene
@export var slider_popup_scene: PackedScene

@export var player_position: int = 2
@export var response_text_edit: TextEdit
@export var messages_container: Container
@export var scroll_container: ScrollContainer
@export var title_label: Label

var scenario: Dictionary


func _ready() -> void:
	_setup_scene()
	_send_responses()
	_create_slider_popup()


func _send_responses() -> void:
	var responses: Array = scenario["responses"]
	for index in responses.size():
		# -2 because it should be _before_ response x-1
		if index - 2 == player_position:
			_wait_for_player_input()
		_random_input_wait()
		_add_message(responses[index]["text"], responses[index]["type"])


func _random_input_wait() -> void:
	pass


func _wait_for_player_input() -> void:
	pass


func _setup_scene() -> void:
	scenario = Scenarios.get_scenario()
	title_label.text = scenario["title"]


func _on_send_button_pressed() -> void:
	_add_message(response_text_edit.text, "true")


func _add_message(text: String, valence: String) -> void:
	var message = message_scene.instantiate()
	message.set_text(text)
	_set_valence(valence, message)
	messages_container.add_child(message)


func _create_slider_popup() -> void:
	var slider_popup = slider_popup_scene.instantiate()
	add_child(slider_popup)


func _set_valence(valence: String, message: Message) -> void:
	match valence:
		"true":
			message.set_truthy()
		"false":
			message.set_falsey()
		"unsure":
			message.set_neutral()
		_:
			push_error("Failed to parse message valence: " + valence)
