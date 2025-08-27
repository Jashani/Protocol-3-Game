extends Control

const FIRST_HEADLINE_RATING_KEY = "belief_prior"
const SECOND_HEADLINE_RATING_KEY = "belief_posterior"
const RELIABILITY_RATING_KEY = "reliability"

@export var message_scene: PackedScene
@export var slider_popup_scene: PackedScene
@export var opinion_popup_scene: PackedScene
@export var next_scene: PackedScene

@export var messages_container: Container
@export var scroll_container: ScrollContainer
@export var title_label: Label
@export var random_timer: Timer

## The player's position in the response order
@export var player_position: int = 2
## Max seconds for a non-player response
@export var max_wait_for_npc_response: float = 3.0
## Min seconds for a non-player response
@export var min_wait_for_npc_response: float = 0.0
## Wait time after preceding response, before player is prompted
@export var wait_before_prompt: float = 3.0
## Wait time after last response
@export var wait_after_last_response: float = 5.0


var round: Round
var random = RandomNumberGenerator.new()


func _ready() -> void:
	round = Scenarios.get_scenario()
	_run()

func _run() -> void:
	Data.new_round(round)
	_setup_scene()
	await _rate_headline(FIRST_HEADLINE_RATING_KEY)
	await _send_responses()
	await get_tree().create_timer(wait_after_last_response).timeout
	_next()

func _rate_headline(key: String) -> void:
	var slider_popup: SliderPopup = _create_slider_popup(key)
	slider_popup.set_title("How likely do you think the headline is to be true?")
	await slider_popup.complete

func _send_responses() -> void:
	var responses: Array = round.responses
	for index in responses.size():
		var response = responses[index]
		if index + 1 == player_position:
			await get_tree().create_timer(wait_before_prompt).timeout
			await _get_player_opinion()
		var affiliation = Globals.str_to_affiliation(response["affiliation"])
		var message = _add_empty_message(affiliation)
		await _wait_random(min_wait_for_npc_response, max_wait_for_npc_response)
		_update_message(message, response["text"], response["type"])

func _get_player_opinion() -> void:
	await _rate_headline(SECOND_HEADLINE_RATING_KEY)
	await _rate_other_player_reliability()
	await _write_opinion()

func _rate_other_player_reliability() -> void:
	var slider_popup: SliderPopup = _create_slider_popup(RELIABILITY_RATING_KEY)
	slider_popup.set_title("""How reliable is the first player? \
							I.e. how likely are they to make an accurate \
							statement in response to the headline""")
	slider_popup.set_left_label("Very unreliable")
	slider_popup.set_right_label("Very reliable")
	await slider_popup.complete

func _write_opinion() -> void:
	var opinion_popup: OpinionPopup = _create_opinion_popup()
	var result = await opinion_popup.complete
	var opinion: String = result[0]
	var text: String = result[1]
	_add_message(text, opinion, Globals.player_affiliation, true)

func _setup_scene() -> void:
	title_label.text = round.title

func _add_message(text: String, valence: String, affiliation: Affiliation,
					is_player: bool = false) -> void:
	var message = message_scene.instantiate()
	messages_container.add_child(message)
	message.set_text(text)
	_set_valence(valence, message)
	message.set_affiliation(affiliation)
	if is_player:
		message.set_icon_left()

func _add_empty_message(affiliation: Affiliation) -> Message:
	var message = message_scene.instantiate()
	message.set_affiliation(affiliation)
	messages_container.add_child(message)
	return message

func _update_message(message: Message, text: String, valence: String) -> void:
	message.set_text(text)
	_set_valence(valence, message)

func _create_slider_popup(key: String) -> SliderPopup:
	var slider_popup: SliderPopup = slider_popup_scene.instantiate()
	slider_popup.set_data_key(key)
	add_child(slider_popup)
	return slider_popup

func _create_opinion_popup() -> OpinionPopup:
	var opinion_popup: OpinionPopup = opinion_popup_scene.instantiate()
	add_child(opinion_popup)
	return opinion_popup

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

func _wait_random(min_seconds: float, max_seconds: float) -> void:
	var wait_time = random.randf_range(min_seconds, max_seconds)
	await get_tree().create_timer(wait_time).timeout

func _next() -> void:
	if Scenarios.remaining_scenarios() == 0:
		get_tree().change_scene_to_packed(next_scene)
	else:
		get_tree().reload_current_scene()
