extends Area2D

@onready var pickup_animation: AnimationPlayer = $PickupAnimation

signal collected


func _on_body_entered(body: Node2D) -> void:
	collected.emit()
	pickup_animation.play("pickup")
