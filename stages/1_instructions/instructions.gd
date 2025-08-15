extends Control


@export var next_scene: PackedScene


func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)
