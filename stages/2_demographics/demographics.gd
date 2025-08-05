extends Control


@export var proceed_button: Button = null
@export var next_scene: PackedScene = null


func _on_affiliation_list_item_selected(index: int) -> void:
	match index:
		0:
			Globals.player_affiliation = Globals.Affiliation.REPUBLICAN
		1:
			Globals.player_affiliation = Globals.Affiliation.DEMOCRAT
		2:
			Globals.player_affiliation = Globals.Affiliation.OTHER
		_:
			push_error("Bad index when selecting player affiliation: " + str(index))
	proceed_button.disabled = false


func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)
