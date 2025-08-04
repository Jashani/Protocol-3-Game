extends Label

@export var base_text: String = "Waiting for other players"
@export var timer: Timer


var dots: String = "."


func _cycle_dots_in_text() -> void:
	if len(dots) >= 3:
		dots = ""
	
	dots += "."
	text = base_text + dots


func _on_seconds_timer_timeout() -> void:
	_cycle_dots_in_text()
