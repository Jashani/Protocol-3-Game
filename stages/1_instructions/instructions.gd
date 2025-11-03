extends Control


@export var next_scene: PackedScene
@export var checkboxes: Array[CheckBox]
@export var submit_button: Button

var checkbox_count = 0

func _ready() -> void:
	for checkbox in checkboxes:
		checkbox.toggled.connect(_on_check_box_toggled)

func _on_proceed_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)

func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		checkbox_count += 1
	else:
		checkbox_count -= 1
	
	submit_button.disabled = checkbox_count < checkboxes.size()
