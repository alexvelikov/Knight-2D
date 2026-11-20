extends Node2D

@export var limit_checkers: Array[RayCast2D]

func return_trigered_checkers() -> Array[RayCast2D]:
	var trigered_checkers: Array[RayCast2D]
	for item in limit_checkers:
		item.is_colliding()
		trigered_checkers.append(item)
	return trigered_checkers
