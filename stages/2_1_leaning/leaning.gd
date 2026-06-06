extends Control


@export var proceed_button: Button = null
@export var next_scene: PackedScene = null
@export var education_options: OptionButton = null
@export var gender_options: OptionButton = null

@export var affiliations: Affiliations

var demographics := Demographics.new()


func _on_proceed_button_pressed() -> void:
	Globals.player_demographics = demographics
	Globals.player_icon = Globals.player_affiliation.random_icon() # TODO: REMOVE!
	get_tree().change_scene_to_packed(next_scene)

func _on_affiliation_list_item_selected(index: int) -> void:
	match index:
		0:
			Globals.player_affiliation = affiliations.republican
		1:
			Globals.player_affiliation = affiliations.democrat
		_:
			push_error("Bad index when selecting player affiliation: " + str(index))
	demographics.affiliation = Globals.player_affiliation.text
	proceed_button.disabled = false
