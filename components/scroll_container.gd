extends ScrollContainer


var scroll_bar: ScrollBar


func _ready() -> void:
	scroll_bar = get_v_scroll_bar()
	scroll_bar.connect("changed", _scroll_down)


func _scroll_down() -> void:
	scroll_vertical = scroll_bar.max_value
