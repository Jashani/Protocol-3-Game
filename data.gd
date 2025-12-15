# We save items as dictionaries per round.
# Then we convert each dictionary into a CSV line.
# This is to make sure a key and its value always
# have the same position.

extends Node

const FILE_PATH: String = "res://test.csv" # TODO: Determine
# Headers without added headers from config
const BUILTIN_HEADERS: PackedStringArray = ["participant_id",
	"participant_affiliation", "age", "education", "gender",
	"feedback", "scenario_id", "headline", "npc_affiliation",
	"comment", "comment_leaning", "post_valence", "post_content"]

var rounds: Array[Dictionary]
var participant_id: int = 0 # TODO: set properly
var headers: PackedStringArray = []

func _ready() -> void:
	check_connectivity()
	call_deferred("_set_headers") # Make sure config has time to load

func check_connectivity():
	pass

func _set_headers() -> void:
	headers += BUILTIN_HEADERS
	var prompts = Config.config['prompts']
	for prompt in prompts:
		headers.append(prompt['column_name'])

func new_round(round: Round) -> void:
	var round_dict = {
		"scenario_id": round.id,
		"participant_id": participant_id,
		"participant_affiliation": Globals.player_demographics.affiliation,
		"education": Globals.player_demographics.education,
		"gender": Globals.player_demographics.gender,
		"age": Globals.player_demographics.age,
		"headline": round.type,
		"npc_affiliation": round.response["affiliation"],
		"comment": round.response["text"],
		"comment_leaning": round.response["type"]
	}
	rounds.append(round_dict)

func save_value(key: String, value):
	assert(rounds.size() > 0, "Trying to save value, but no rounds!")
	rounds[-1][key] = value

func save_for_all_rounds(key: String, value):
	for _round in rounds:
		_round[key] = value

func save_file():
	var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed opening file: " + str(FileAccess.get_open_error()))

	file.store_csv_line(headers)

	for round in rounds:
		var row: PackedStringArray = []
		for header in headers:
			var value = str(round.get(header, ""))
			row.append(value)
		
		file.store_csv_line(row)
	
	file.flush()
	file.close()
	return true
