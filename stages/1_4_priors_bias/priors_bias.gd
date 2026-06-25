extends Control

@export var next_scene: PackedScene

@onready var _proceed_button: Button = $ScrollContainer/MainVBox/ProceedRow/ProceedButton

var _touched := {}
const _REQUIRED := ["rep_crime", "rep_edu", "rep_imm", "rep_env",
					"dem_crime", "dem_edu", "dem_imm", "dem_env"]


func _ready() -> void:
	if randi() % 2 == 0:
		%SectionsContainer.move_child(%DemSection, 0)
	_proceed_button.disabled = true


func _mark_touched(key: String) -> void:
	_touched[key] = true
	_proceed_button.disabled = not _REQUIRED.all(func(k): return _touched.has(k))


func _on_rep_crime_slider_value_changed(value: float) -> void:
	%RepCrimeValue.text = str(int(value))

func _on_rep_crime_slider_drag_started() -> void:
	_mark_touched("rep_crime")

func _on_rep_education_slider_value_changed(value: float) -> void:
	%RepEducationValue.text = str(int(value))

func _on_rep_education_slider_drag_started() -> void:
	_mark_touched("rep_edu")

func _on_rep_immigration_slider_value_changed(value: float) -> void:
	%RepImmigrationValue.text = str(int(value))

func _on_rep_immigration_slider_drag_started() -> void:
	_mark_touched("rep_imm")

func _on_rep_environment_slider_value_changed(value: float) -> void:
	%RepEnvironmentValue.text = str(int(value))

func _on_rep_environment_slider_drag_started() -> void:
	_mark_touched("rep_env")

func _on_dem_crime_slider_value_changed(value: float) -> void:
	%DemCrimeValue.text = str(int(value))

func _on_dem_crime_slider_drag_started() -> void:
	_mark_touched("dem_crime")

func _on_dem_education_slider_value_changed(value: float) -> void:
	%DemEducationValue.text = str(int(value))

func _on_dem_education_slider_drag_started() -> void:
	_mark_touched("dem_edu")

func _on_dem_immigration_slider_value_changed(value: float) -> void:
	%DemImmigrationValue.text = str(int(value))

func _on_dem_immigration_slider_drag_started() -> void:
	_mark_touched("dem_imm")

func _on_dem_environment_slider_value_changed(value: float) -> void:
	%DemEnvironmentValue.text = str(int(value))

func _on_dem_environment_slider_drag_started() -> void:
	_mark_touched("dem_env")


func _on_proceed_button_pressed() -> void:
	_save_data()
	get_tree().change_scene_to_packed(next_scene)


func _save_data() -> void:
	Data.save_globally("prior_bias_republican_crime", %RepCrimeSlider.value)
	Data.save_globally("prior_bias_republican_education", %RepEducationSlider.value)
	Data.save_globally("prior_bias_republican_immigration", %RepImmigrationSlider.value)
	Data.save_globally("prior_bias_republican_environment", %RepEnvironmentSlider.value)
	Data.save_globally("prior_bias_democrat_crime", %DemCrimeSlider.value)
	Data.save_globally("prior_bias_democrat_education", %DemEducationSlider.value)
	Data.save_globally("prior_bias_democrat_immigration", %DemImmigrationSlider.value)
	Data.save_globally("prior_bias_democrat_environment", %DemEnvironmentSlider.value)
