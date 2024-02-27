extends Node

var current_expirience: float = 0


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_expirience(number: float):
	current_expirience += number
	print("Expirience: ", current_expirience)


func on_experience_vial_collected(number: float):
	increment_expirience(number)
