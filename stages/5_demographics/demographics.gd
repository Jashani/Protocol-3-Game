extends Control


@export var proceed_button: Button = null
@export var next_scene: PackedScene = null
@export var education_options: OptionButton = null
@export var gender_options: OptionButton = null

@export var affiliations: Affiliations

var demographics := Globals.player_demographics


func _check_completion() -> void:
	var fields := [demographics.education, demographics.gender,
				   demographics.age]
	if not fields.has("") and not fields.has(0):
		proceed_button.disabled = false

func _on_proceed_button_pressed() -> void:
	_save_demographics()
	get_tree().change_scene_to_packed(next_scene)

 # I don't like how this is implemented but whatever
func _save_demographics() -> void:
	Data.save_for_all_rounds("age", demographics.age)
	Data.save_for_all_rounds("gender", demographics.gender)
	Data.save_for_all_rounds("education", demographics.education)

func _on_age_box_value_changed(value: float) -> void:
	demographics.age = int(value)
	_check_completion()

func _on_education_options_item_selected(index: int) -> void:
	demographics.education = education_options.get_item_text(index)
	_check_completion()

func _on_gender_options_item_selected(index: int) -> void:
	demographics.gender = gender_options.get_item_text(index)
	_check_completion()
