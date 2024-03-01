extends Node

signal experience_updated(current_expirience: float, target_experience: float)

const TARGET_EXPERIENCE_GROWTH = 5

var current_expirience: float = 0
var current_level: int = 1
var target_experience: float = 5


func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)


func increment_expirience(number: float):
	current_expirience = min(current_expirience + number, target_experience)
	experience_updated.emit(current_expirience, target_experience)
	if current_expirience == target_experience:
		current_level += 1
		target_experience = target_experience * TARGET_EXPERIENCE_GROWTH
		current_expirience = 0
		experience_updated.emit(current_expirience, target_experience)


func on_experience_vial_collected(number: float):
	increment_expirience(number)
