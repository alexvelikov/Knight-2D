extends Area2D
class_name HurtboxManager

@export var damaged_by: StringName
@export var damage: float

signal hit_something(target: Area2D)
signal took_damage(amount: float)


func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_area_entered(area: Area2D):
	if area.is_in_group(damaged_by):
		hit_something.emit(area)
		took_damage.emit(area.damage)

func _on_body_entered(body: Area2D):
	if body.is_in_group(damaged_by):
		hit_something.emit(body)
		took_damage.emit(body.damage)
