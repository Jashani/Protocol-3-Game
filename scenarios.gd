extends Node

@export var scenarios_path = "res://scenarios.json"

var scenarios: Array


func _ready() -> void:
	_load_scenarios()


func get_scenario() -> Dictionary:
	return scenarios.pop_front()


func remaining_scenarios() -> int:
	return scenarios.size()


func _load_scenarios() -> void:
	var scenarios_json = FileAccess.get_file_as_string(scenarios_path)
	var _scenarios = JSON.parse_string(scenarios_json)
	assert(_scenarios != null, "Failed to load scenarios!")
	scenarios = _scenarios
