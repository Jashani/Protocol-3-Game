extends Label

signal reached_max_players

@export var timer: Timer
@export var max_players: int = 4
@export var max_player_wait_seconds: float = 10.0

var random = RandomNumberGenerator.new()
var current_players: int


func _ready() -> void:
	current_players = random.randi_range(1, max_players - 1) # -1 because of below
	# For some reason, changing scenes immediately upon ready totally breaks everything...
	# We work around this with the -1 above.
	#if current_players == max_players:
		#emit_signal("reached_max_players")
	_update_label()
	_randomize_add_player()


func _update_label() -> void:
	text = str(current_players) + "/" + str(max_players)


func _add_player() -> void:
	current_players += 1
	_update_label()
	if current_players == max_players:
		emit_signal("reached_max_players")
		return
	_randomize_add_player()


func _randomize_add_player() -> void:
	var wait_time = random.randf_range(0, max_player_wait_seconds)
	timer.wait_time = wait_time
	timer.start()


func _on_random_timer_timeout() -> void:
	_add_player()
