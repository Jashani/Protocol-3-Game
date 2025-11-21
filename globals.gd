extends Node

enum Opinion {SUPPORT, UNSURE, OPPOSE}

var player_icon: Texture
var player_demographics: Demographics
var player_affiliation: Affiliation
var affiliations: Affiliations = preload("res://resources/affiliations.tres")


func str_to_affiliation(string: String) -> Affiliation:
	match string.to_lower():
		"right":
			return affiliations.republican
		"left":
			return affiliations.democrat
		_:
			push_error("Failed to parse str to affiliation: " + string)
	return null


func str_to_opinion(string: String) -> Opinion:
	match string.to_lower():
		"support":
			return Opinion.SUPPORT
		"unsure":
			return Opinion.UNSURE
		"oppose":
			return Opinion.OPPOSE
		_:
			push_error("Failed to parse str to opinion: " + string)
	return -1
