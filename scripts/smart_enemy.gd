extends Node2D

var target_in_range: Node2D = null
@onready var ground_check_right: RayCast2D = $GroundCheckers/GroundCheckRight
@onready var ground_check_left: RayCast2D = $GroundCheckers/GroundCheckLeft
var direction := 1
var SPEED := 90

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerDetectionArea.body_entered.connect(_on_body_entered)
	$PlayerDetectionArea.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target_in_range = body

func _on_body_exited(body: Node2D) -> void:
	if body == target_in_range:
		target_in_range = null

func _idle() -> void:
	pass

func _step_towards_target():
	if _floor_ends():
		_idle()
	else:
		var direction: float = sign(target_in_range.global_position.x - global_position.x)
		position.x = direction * SPEED

func _patrol() -> void:
	position.x = SPEED * direction
	if _floor_ends():
		direction *= -1
	
func _floor_ends() -> bool:
	if ground_check_left.is_colliding() || ground_check_right.is_colliding():
		return true
	else:
		return false
