extends Control


@export var next_scene: PackedScene
@export var submit_button: Button

var checkbox_count = 0

func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)
