extends Node

@onready var timer: Timer = $Timer

@export var heal_delay := 10
@export var heal_amount := 5
@export var health_manager: HealthManager
@export var health_bar: HealthBar
var hit := false


func _ready() -> void:
	timer.timeout.connect(start_healing)

func start_healing_cooldown():
	hit = true
	timer.start(heal_delay)

func start_healing():
	while health_manager.health < health_manager.max_health:
		if hit:
			hit = false
			break
		health_manager.heal(heal_amount)
		health_bar.increase(heal_amount)
		await get_tree().create_timer(2).timeout
