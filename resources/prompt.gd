class_name Prompt
extends Resource

enum Stage {BEFORE, AFTER}
enum Type {SLIDER}

@export var type: Prompt.Type
@export var min_value: float
@export var max_value: float
@export var left_label: String
@export var right_label: String
@export var text: String
@export var column_name: String
@export var stage: Prompt.Type


static func type_from_str(string: String):
	if string.to_lower() == "slider":
		return Type.SLIDER
	push_error("Failed to convert to type: " + string)

static func stage_from_str(string: String):
	string = string.to_lower()
	if string == "before":
		return Stage.BEFORE
	elif string == "after":
		return Stage.AFTER
	push_error("Failed to convert to stage: " + string)
