extends Node

enum Opinion {SUPPORT, UNSURE, OPPOSE}

var player_affiliation: Affiliation


func str_to_affiliation(str: String) -> Affiliation:
	match str.to_lower():
		"republican":
			return Affiliation.REPUBLICAN
		"democraft":
			return Affiliation.DEMOCRAT
		"other":
			return Affiliation.OTHER
		_:
			push_error("Failed to parse str to affiliation: " + str)
	return -1


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
