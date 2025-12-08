extends Control


func _ready() -> void:
	await Data.save_file()
	print("All done!")
	
