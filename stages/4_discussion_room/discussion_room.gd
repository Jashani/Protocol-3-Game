extends Control

@export var message_scene: PackedScene
@export var slider_popup_scene: PackedScene
@export var opinion_popup_scene: PackedScene
@export var next_scene: PackedScene

@export var chat_container: PanelContainer
@export var messages_container: Container
@export var scroll_container: ScrollContainer
@export var title_label: Label
@export var bias_slider: BiasSlider
@export var next_button: Button

## Max seconds for a non-player response
@export var max_wait_for_npc_response: float = 3.0
## Min seconds for a non-player response
@export var min_wait_for_npc_response: float = 0.0
## Wait time after preceding response, before player is prompted
@export var wait_before_prompt: float = 3.0
## Wait time after last response
@export var wait_after_last_response: float = 5.0

@export var min_bias_meter_range: float = 40.0
@export var max_bias_meter_range: float = 60.0

@export var use_bias_meter: bool = true

var round: Round
var random = RandomNumberGenerator.new()
var player_played: bool = false
var prompts_before: Array[Prompt]
var prompts_after: Array[Prompt]
var last_slider_value: float

func _ready() -> void:
	round = Scenarios.get_scenario()
	_get_prompts()
	_setup_scene()

func _run() -> void:
	await _run_prompts(prompts_before)
	await _send_response()
	await get_tree().create_timer(wait_before_prompt).timeout
	await _run_prompts(prompts_after)
	await _write_opinion()
	await get_tree().create_timer(wait_after_last_response).timeout
	_next()

func _get_prompts() -> void:
	var prompts: Array = Config.config['prompts']
	for prompt in prompts:
		var prompt_resource = Prompt.new_from_dict(prompt)
		if prompt_resource.stage == Prompt.Stage.BEFORE:
			prompts_before.append(prompt_resource)
		elif prompt_resource.stage == Prompt.Stage.AFTER:
			prompts_after.append(prompt_resource)

func _run_prompts(prompts: Array[Prompt]) -> void:
	for prompt in prompts:
		await _run_prompt(prompt)

func _run_prompt(prompt: Prompt) -> void:
	if prompt.type == Prompt.Type.SLIDER:
		var slider_popup = _create_slider_popup_from_prompt(prompt)
		await slider_popup.complete
		last_slider_value = slider_popup.slider.value

func _create_slider_popup_from_prompt(prompt: Prompt) -> SliderPopup:
	var slider_popup: SliderPopup = slider_popup_scene.instantiate()
	if prompt.use_previous:
		prompt.value = last_slider_value
	slider_popup.from_resource(prompt)
	chat_container.add_child(slider_popup)
	return slider_popup

func _send_response() -> void:
	var response: Dictionary = round.response
	await _post_npc_response(response)

func _post_npc_response(response: Dictionary) -> void:
	var affiliation = Globals.str_to_affiliation(response["affiliation"])
	var message = _add_empty_message(affiliation)
	await _wait_random(min_wait_for_npc_response, max_wait_for_npc_response)
	_update_message(message, response["text"], response["type"])

func _write_opinion() -> void:
	var opinion_popup: OpinionPopup = _create_opinion_popup()
	var result = await opinion_popup.complete
	var opinion: String = result[0]
	var text: String = result[1]
	_add_message(text, opinion, Globals.player_affiliation, true)

func _setup_scene() -> void:
	Data.new_round(round)
	bias_slider.visible = false
	title_label.text = round.title
	_set_bias()

func _set_bias() -> void:
	var bias = random.randf_range(min_bias_meter_range, max_bias_meter_range)
	if round.leaning == "left":
		bias *= -1
	bias_slider.set_value(bias)

func _add_message(text: String, valence: String, affiliation: Affiliation,
					is_player: bool = false) -> void:
	var message: Message = message_scene.instantiate()
	messages_container.add_child(message)
	message.set_text(text)
	_set_valence(valence, message)
	message.set_affiliation(affiliation)
	if is_player:
		message.set_icon(Globals.player_icon)
		message.set_icon_left()

func _add_empty_message(affiliation: Affiliation) -> Message:
	var message = message_scene.instantiate()
	message.set_affiliation(affiliation)
	messages_container.add_child(message)
	return message

func _update_message(message: Message, text: String, valence: String) -> void:
	message.set_text(text)
	_set_valence(valence, message)

func _create_opinion_popup() -> OpinionPopup:
	var opinion_popup: OpinionPopup = opinion_popup_scene.instantiate()
	chat_container.add_child(opinion_popup)
	return opinion_popup

func _set_valence(valence: String, message: Message) -> void:
	match valence:
		"support":
			message.set_truthy()
		"oppose":
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

func _on_next_button_pressed() -> void:
	next_button.visible = false
	if use_bias_meter:
		bias_slider.visible = true
	_run()
