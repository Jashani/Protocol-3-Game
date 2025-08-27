extends Control


@export var proceed_button: Button = null
@export var next_scene: PackedScene = null
@export var education_options: OptionButton = null
@export var gender_options: OptionButton = null

@export var affiliations: Affiliations

var demographics := Demographics.new()


func _check_completion() -> void:
	var fields := [demographics.affiliation, demographics.education,
				   demographics.gender, demographics.age]
	if not fields.has("") and not fields.has(0):
		proceed_button.disabled = false

func _on_proceed_button_pressed() -> void:
	Globals.player_demographics = demographics
	get_tree().change_scene_to_packed(next_scene)

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
	demographics.affiliation = Globals.player_affiliation.text
	_check_completion()

func _on_age_box_value_changed(value: float) -> void:
	demographics.age = int(value)
	_check_completion()

func _on_education_options_item_selected(index: int) -> void:
	demographics.education = education_options.get_item_text(index)
	_check_completion()

func _on_gender_options_item_selected(index: int) -> void:
	demographics.gender = gender_options.get_item_text(index)
	_check_completion()
