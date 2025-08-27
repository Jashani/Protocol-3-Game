extends Node

enum Opinion {SUPPORT, UNSURE, OPPOSE}

var player_demographics: Demographics
var player_affiliation: Affiliation = preload("res://resources/other_affiliation.tres") # TODO: Don't preload this
var affiliations: Affiliations = preload("res://resources/affiliations.tres")


func str_to_affiliation(str: String) -> Affiliation:
	match str.to_lower():
		"republican":
			return affiliations.republican
		"democrat":
			return affiliations.democrat
		"other":
			return affiliations.other
		_:
			push_error("Failed to parse str to affiliation: " + str)
	return null


func str_to_opinion(str: String) -> Opinion:
	match str.to_lower():
		"support":
			return Opinion.SUPPORT
		"unsure":
			return Opinion.UNSURE
		"oppose":
			return Opinion.OPPOSE
		_:
			push_error("Failed to parse str to opinion: " + str)
	return -1
