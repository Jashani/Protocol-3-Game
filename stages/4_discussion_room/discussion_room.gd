extends Control


@export var message_scene: PackedScene
@export var slider_popup_scene: PackedScene

@export var response_text_edit: TextEdit
@export var messages_container: Container
@export var scroll_container: ScrollContainer
@export var title_label: Label
@export var random_timer: Timer

# The player's position in the response order
@export var player_position: int = 2
# Max seconds for a non-player response
@export var max_wait_for_npc_response: float = 3.0

var scenario: Dictionary

var random = RandomNumberGenerator.new()


func _ready() -> void:
	_setup_scene()
	_send_responses()


func _send_responses() -> void:
	var responses: Array = scenario["responses"]
	for index in responses.size():
		if index + 1 == player_position:
			await _wait_for_player_input()
		await _wait_random(max_wait_for_npc_response)
		_add_message(responses[index]["text"], responses[index]["type"])


func _wait_for_player_input() -> void:
	var slider_popup: SliderPopup = _create_slider_popup()
	await slider_popup.complete


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


func _create_slider_popup() -> SliderPopup:
	var slider_popup = slider_popup_scene.instantiate()
	add_child(slider_popup)
	return slider_popup


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


func _wait_random(max_seconds: float) -> void:
	var wait_time = random.randf_range(0, max_seconds)
	await get_tree().create_timer(wait_time).timeout
