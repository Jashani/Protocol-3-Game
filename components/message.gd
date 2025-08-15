class_name Message

extends HBoxContainer

@export var response_label: Label
@export var backround_panel: PanelContainer
@export var icon: TextureRect
@export var affiliation_label: Label

@export var true_style: StyleBoxFlat
@export var false_style: StyleBoxFlat
@export var neutral_style: StyleBoxFlat


func set_affiliation(affiliation: Affiliation) -> void:
	icon.texture = affiliation.icon
	affiliation_label.text = affiliation.text
	affiliation_label.add_theme_color_override('font_color', affiliation.color)


func set_icon_left() -> void:
	move_child(backround_panel, 1)

func set_text(text: String) -> void:
	response_label.text = text

func set_truthy() -> void:
	_override_style(true_style)

func set_falsey() -> void:
	_override_style(false_style)

func set_neutral() -> void:
	_override_style(neutral_style)

func _override_style(style: StyleBox) -> void:
	backround_panel.add_theme_stylebox_override("panel", style)
