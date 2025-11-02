extends Control


@export var next_scene: PackedScene = null
@export var min_wait_time: float = 5.0
@export var max_wait_time: float = 15.0

var random = RandomNumberGenerator.new()


func _ready() -> void:
	var wait_time = random.randf_range(min_wait_time, max_wait_time)
	await get_tree().create_timer(wait_time).timeout
	get_tree().change_scene_to_packed(next_scene)
