extends Control


func _ready() -> void:
	await Data.save_data()
	print("All done!")
	
