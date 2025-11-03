extends Node

@export var config_path = "res://config.json"

var config: Dictionary

func _ready() -> void:
	_load_config()

func _load_config() -> void:
	var config_json = FileAccess.get_file_as_string(config_path)
	config = JSON.parse_string(config_json)
	assert(config != null, "Failed to load config!")
