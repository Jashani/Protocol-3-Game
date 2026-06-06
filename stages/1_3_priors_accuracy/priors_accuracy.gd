extends Control

@export var next_scene: PackedScene


func _ready() -> void:
	if randi() % 2 == 0:
		%SectionsContainer.move_child(%DemSection, 0)


func _on_rep_crime_slider_value_changed(value: float) -> void:
	%RepCrimeValue.text = str(int(value))

func _on_rep_education_slider_value_changed(value: float) -> void:
	%RepEducationValue.text = str(int(value))

func _on_rep_immigration_slider_value_changed(value: float) -> void:
	%RepImmigrationValue.text = str(int(value))

func _on_rep_environment_slider_value_changed(value: float) -> void:
	%RepEnvironmentValue.text = str(int(value))

func _on_dem_crime_slider_value_changed(value: float) -> void:
	%DemCrimeValue.text = str(int(value))

func _on_dem_education_slider_value_changed(value: float) -> void:
	%DemEducationValue.text = str(int(value))

func _on_dem_immigration_slider_value_changed(value: float) -> void:
	%DemImmigrationValue.text = str(int(value))

func _on_dem_environment_slider_value_changed(value: float) -> void:
	%DemEnvironmentValue.text = str(int(value))


func _on_proceed_button_pressed() -> void:
	_save_data()
	get_tree().change_scene_to_packed(next_scene)


func _save_data() -> void:
	Data.save_globally("prior_accuracy_republican_crime", %RepCrimeSlider.value)
	Data.save_globally("prior_accuracy_republican_education", %RepEducationSlider.value)
	Data.save_globally("prior_accuracy_republican_immigration", %RepImmigrationSlider.value)
	Data.save_globally("prior_accuracy_republican_environment", %RepEnvironmentSlider.value)
	Data.save_globally("prior_accuracy_democrat_crime", %DemCrimeSlider.value)
	Data.save_globally("prior_accuracy_democrat_education", %DemEducationSlider.value)
	Data.save_globally("prior_accuracy_democrat_immigration", %DemImmigrationSlider.value)
	Data.save_globally("prior_accuracy_democrat_environment", %DemEnvironmentSlider.value)
