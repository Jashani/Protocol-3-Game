class_name Message

extends HBoxContainer

@export var response_label: Label
@export var backround_panel: PanelContainer
@export var icon: TextureRect

@export var true_style: StyleBoxFlat
@export var false_style: StyleBoxFlat
@export var neutral_style: StyleBoxFlat

@export var rep_icon: Texture
@export var dem_icon: Texture
@export var other_icon: Texture


func set_affiliation(affiliation: Globals.Affiliation) -> void:
	match affiliation:
		Globals.Affiliation.REPUBLICAN:
			icon.texture = rep_icon
		Globals.Affiliation.DEMOCRAT:
			icon.texture = dem_icon
		Globals.Affiliation.OTHER:
			icon.texture = other_icon
		_:
			push_error("Failed to identify affiliation when setting icon")

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
