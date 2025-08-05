extends Control


@export var next_scene: PackedScene = null


func _on_player_count_reached_max_players() -> void:
	get_tree().change_scene_to_packed(next_scene)
