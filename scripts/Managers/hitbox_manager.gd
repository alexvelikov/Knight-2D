extends Area2D
class_name HitboxManager

signal hit_something(target)
signal took_damage(amount)
@export var target_group: StringName


func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _on_area_entered(area: Area2D):
	if area.is_in_group(target_group):
		hit_something.emit(area)
		took_damage.emit(area.damage)
		print("Collided")

func _on_body_entered(body: Node2D):
	if body.is_in_group(target_group):
		hit_something.emit(body)
		took_damage.emit(body.damage)
