extends Node

@export var scenarios_path = "res://scenarios.json"

var scenarios: Array[Round]


func _ready() -> void:
	_load_random_scenarios()
	scenarios.shuffle()

func get_scenario() -> Round:
	return scenarios.pop_front()

func remaining_scenarios() -> int:
	return scenarios.size()

func _load_random_scenarios() -> void:
	var scenarios_json = FileAccess.get_file_as_string(scenarios_path)
	var topics = JSON.parse_string(scenarios_json)
	assert(topics != null, "Failed to load scenarios!")
	for topic in topics:
		var left = _build_random_scenario(topic['left'],
										  topic['type'], 'left')
		var right = _build_random_scenario(topic['right'],
										   topic['type'], 'right')
		scenarios.append(left)
		scenarios.append(right)

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
	_round.responses = scenario['responses']
	_round.type = type
	return _round
