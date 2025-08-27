extends Control


@export var proceed_button: Button = null
@export var next_scene: PackedScene = null

@export var affiliations: Affiliations

func _ready() -> void:
	_set_demographics()

func _set_demographics() -> void: # TODO: implement!
	var demographics := Demographics.new()
	demographics.affiliation = "some_affiliation"
	demographics.education = "some_education"
	demographics.gender = "some_gender"
	demographics.age = 99
	Globals.player_demographics = demographics

func _on_affiliation_list_item_selected(index: int) -> void:
	match index:
		0:
			Globals.player_affiliation = affiliations.republican
		1:
			Globals.player_affiliation = affiliations.democrat
		2:
			Globals.player_affiliation = affiliations.other
		_:
			push_error("Bad index when selecting player affiliation: " + str(index))
	proceed_button.disabled = false

func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)
