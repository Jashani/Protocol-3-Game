# We save items as dictionaries per round.
# Then we convert each dictionary into a CSV line.
# This is to make sure a key and its value always
# have the same position.

extends Node

const FILE_PATH: String = "" # TODO: Determine
const HEADERS: PackedStringArray = ["participant_id",
	"participant_affiliation", "age", "education",
	"gender", "round", "headline", "player_affiliation",
	"comment", "belief_prior", "belief_posterior",
	"reliability", "post_valence", "post_content"]

var rounds: Array[Dictionary]
var participant_id: int

func _ready() -> void:
	check_connectivity()

func check_connectivity():
	pass

func new_round(round: Round) -> void:
	var round_dict = {
		"round": round.id,
		"participant_id": participant_id,
		"participant_affiliation": Globals.player_demographics.affiliation,
		"education": Globals.player_demographics.education,
		"gender": Globals.player_demographics.gender,
		"age": Globals.player_demographics.age,
		"headline": round.type,
		"player_affiliation": round.responses[0]["affiliation"],
		"comment": round.responses[0]["type"] # TODO: Validate this is correct
	}
	rounds.append({})

func save_value(key: String, value):
	assert(rounds.size() > 0, "Trying to save value, but no rounds!")
	rounds[-1][key] = value

func save_file():
	var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed opening file: " + str(FileAccess.get_open_error()))

	file.store_csv_line(HEADERS)
	
	for round in rounds:
		var row: PackedStringArray
		for header in HEADERS:
			var value = str(round.get(header, ""))
			row.append(value)
		
		file.store_csv_line(row)
	
	file.flush()
