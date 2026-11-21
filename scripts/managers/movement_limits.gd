extends Node2D

@export var raycasters_dict: Dictionary[String, RayCast2D]


func return_trigered_raycasters() -> Dictionary[String, RayCast2D]:
	var trigered_checkers: Dictionary[String, RayCast2D]
	for key in raycasters_dict:
		raycasters_dict[key].is_colliding()
		trigered_checkers[key].append(key)
	return trigered_checkers

func any_raycasters_trigered() -> bool:
	for key in raycasters_dict:
		if raycasters_dict[key].is_colliding():
			return true
	return false

func all_raycasters_trigered() -> bool:
	for key in raycasters_dict:
		if not raycasters_dict[key].is_colliding():
			return false
	return true

func no_raycasters_trigered() -> bool:
	for key in raycasters_dict:
		if raycasters_dict[key].is_colliding():
			return false
	return true
