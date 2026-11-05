extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0
var is_alive:bool
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	is_alive = true

func _physics_process(delta: float) -> void:
	if is_alive:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			animated_sprite.play("Jump")
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("go_left", "go_right")
		if direction == 0:
			animated_sprite.play("Idle")
		elif direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true
		
		if direction:
			animated_sprite.play("Run")
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	else:
		animated_sprite.play("Death")
	
	move_and_slide()
