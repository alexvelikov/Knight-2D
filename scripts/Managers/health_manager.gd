extends Node
class_name HealthManager

@export var health: float
@export var max_health: float
@export var min_health: float
@export var crit_health: float
signal died


func take_damage(damage: float):
	health -= damage
	if health <= min_health:
		health = min_health
		died.emit()
	
func heal(amount: float):
	health += amount
	if health > max_health:
		health = max_health
