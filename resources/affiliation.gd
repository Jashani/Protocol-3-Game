class_name Affiliation

extends Resource

enum {REPUBLICAN, DEMOCRAT}

@export var text: String
@export var color: Color
@export var icons: Array[Texture]


func random_icon() -> Texture:
	return icons.pick_random()
