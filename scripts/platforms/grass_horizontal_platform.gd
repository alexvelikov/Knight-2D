extends AnimatableBody2D

@export var first_position: Vector2
@export var second_position: Vector2
@export var time: float
var dir := 1
@onready var total_distance = first_position.distance_to(second_position)
@onready var speed = total_distance / time

func _ready() -> void:
	global_position = Vector2(90, -11)

func _process(delta: float) -> void:
	global_position = global_position.move_toward(second_position, speed * delta)
	if global_position == first_position:
		dir = 1
	elif global_position == second_position:
		dir = -1
