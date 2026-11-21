extends Area2D

@onready var timer: Timer = $Timer


func _on_body_entered(body: Node2D) -> void:
	Engine.time_scale = 0.2
	var body_to_kill = body.get_node("PlayerShape")
	body_to_kill.queue_free()
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1
	
