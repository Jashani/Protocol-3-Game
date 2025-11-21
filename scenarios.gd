extends Node

@export var scenarios_path = "res://scenarios.json"

var scenarios: Array[Round]

var scenarios_config: Dictionary

func _ready() -> void:
	_load_config()
	_build_response_pool()
	_load_random_scenarios()
	scenarios.shuffle()

func _load_config() -> void:
	var scenarios_json = FileAccess.get_file_as_string(scenarios_path)
	scenarios_config = JSON.parse_string(scenarios_json)
	assert(scenarios_config != null, "Failed to load scenarios!")

func get_scenario() -> Round:
	return scenarios.pop_front()

func remaining_scenarios() -> int:
	return scenarios.size()

func _load_random_scenarios() -> void:
	var arrangements = scenarios_config["arrangements"]
	var response_pool = _build_response_pool()
	var scenario_pools = _build_scenario_pools()
	for arrangement in arrangements:
		var scenario = scenario_pools[arrangement["headline"]].pop_front()
		var response_text = response_pool.pop_front()[arrangement["stance"]]
		var response = {"type": arrangement["stance"], "text": response_text,
						"affiliation": arrangement["comment"]}
		scenario.response = response
		scenarios.append(scenario)

func _build_response_pool() -> Array:
	var response_pool = scenarios_config["responses"]
	response_pool.shuffle()
	return response_pool

func _build_scenario_pools() -> Dictionary:
	var topics = scenarios_config["headlines"]
	var left_scenarios = []
	var right_scenarios = []
	for topic in topics:
		var left = _build_random_scenario(topic['left'],
										  topic['type'], 'left')
		var right = _build_random_scenario(topic['right'],
										   topic['type'], 'right')
		left_scenarios.append(left)
		right_scenarios.append(right)
	left_scenarios.shuffle()
	right_scenarios.shuffle()
	return { "left": left_scenarios,
			 "right": right_scenarios }

func _build_random_scenario(_scenarios: Array, topic: String,
							leaning: String) -> Round:
	var random_scenario = _scenarios.pick_random()
	var type = leaning + "_" + topic
	var _round = _scenario_to_object(random_scenario, type)
	return _round

func _scenario_to_object(scenario: Dictionary, type: String) -> Round:
	var _round := Round.new()
	_round.id = scenario['id']
	_round.title = scenario['title']
	_round.type = type
	return _round
