class_name Affiliation

extends Resource

enum {REPUBLICAN, DEMOCRAT, OTHER}

@export var text: String
@export var color: Color
@export var default_icon: Texture
@export var icons: Array[Texture]


func random_icon() -> Texture:
	return icons.pick_random()
