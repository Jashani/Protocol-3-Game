extends Node

@export var scenarios_path = "res://scenarios.json"

var scenarios: Array[Round]


func _ready() -> void:
	_load_scenarios()

func get_scenario() -> Round:
	return scenarios.pop_front()

func remaining_scenarios() -> int:
	return scenarios.size()

func _load_scenarios() -> void:
	var scenarios_json = FileAccess.get_file_as_string(scenarios_path)
	var _scenarios = JSON.parse_string(scenarios_json)
	assert(_scenarios != null, "Failed to load scenarios!")
	for scenario in _scenarios:
		var round = _scenario_to_object(scenario)
		scenarios.append(round)

func _scenario_to_object(scenario: Dictionary) -> Round:
	var round := Round.new()
	round.id = scenario['id']
	round.title = scenario['title']
	round.responses = scenario['responses']
	round.type = scenario['type']
	return round
