extends Area2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var swing_cooldown: Timer = $SwingCooldown
@onready var shape: CollisionShape2D = $CollisionShape2D
@export var damage := 10.0
@export var swing_time := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shape.set_deferred("disabled", true)
	animation.play("Idle")
	animation.animation_finished.connect(_on_swing_animation_finished)


func _physics_process(delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		attack()
		
func set_flip_h(is_flipped: bool):
	animation.flip_h = is_flipped

func attack():
	if not swing_cooldown.is_stopped():
		return
	swing_cooldown.start()
	
	animation.play("Swing")
	shape.set_deferred("disabled", false)
	await get_tree().create_timer(swing_time).timeout   # active frames
	shape.set_deferred("disabled", true)
	await animation.animation_finished

func _on_swing_animation_finished():
	print("animation finished")
	if animation.animation == &"Swing":
		animation.play("Idle")
