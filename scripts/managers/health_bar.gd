extends Control
class_name HealthBar

@onready var main_bar: ProgressBar = $MainBar
@onready var delaied_bar: ProgressBar = $DelaiedBar
@onready var timer: Timer = $Timer

@export var health: float
@export var max_health: float
@export var min_health: float


func _ready() -> void:
	main_bar.value = health
	main_bar.max_value = max_health
	main_bar.min_value = min_health
	
	delaied_bar.value = health
	delaied_bar.max_value = max_health
	delaied_bar.min_value = min_health

func update(current: float, maximum: float):
	main_bar.max_value = maximum
	delaied_bar.max_value = maximum
	main_bar.value = current
	delaied_bar.value = current

func reduce(amount: float):
	main_bar.value -= amount
	timer.start()

func increase(amount: float):
	main_bar.value += amount
	delaied_bar.value += amount

func _on_timer_timeout() -> void:
	delaied_bar.value = main_bar.value
