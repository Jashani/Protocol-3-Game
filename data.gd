# We save items as dictionaries per round.
# Then we convert each dictionary into a CSV line.
# This is to make sure a key and its value always
# have the same position.

extends Node

const FILE_PATH: String = "res://test.json"


var rounds: Array[Dictionary]
var participant_id: int = 0 # TODO: set properly
var results: Dictionary

func _ready() -> void:
	check_connectivity()
	save_globally("participant_id", participant_id)
	call_deferred("_set_headers") # Make sure config has time to load

func check_connectivity():
	pass

func new_round(round: Round) -> void:
	var round_dict = {
		"scenario_id": round.id,
		"headline_type": round.type,
		"npc_affiliation": round.response["affiliation"],
		"comment": round.response["text"],
		"comment_leaning": round.response["type"]
	}
	rounds.append(round_dict)

func save_value(key: String, value):
	assert(rounds.size() > 0, "Trying to save value, but no rounds!")
	rounds[-1][key] = value

func save_globally(key: String, value):
	results[key] = value

func save_data():
	results['rounds'] = rounds
	print(results)
	
	if OS.has_feature("web"):
		print("Sending data to JS...")
		send_results_to_jspsych()
	else:
		print("Not running in browser, saving locally...")
		save_file()

func save_file():
	var file: FileAccess = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Failed opening file: " + str(FileAccess.get_open_error()))

	file.store_var(results)
	file.flush()
	file.close()
	return true

func send_results_to_jspsych(): 
	var window = JavaScriptBridge.get_interface("window")
	var json_data = JSON.stringify(results)
	# Defined in JS
	window.parent.receiveGodotData(json_data)
