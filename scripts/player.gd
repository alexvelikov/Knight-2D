extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword: Area2D = $Sword

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -300.0
var is_alive:bool
const swordPositionX = 9
const swordPositionY = -9


func _ready() -> void:
	is_alive = true

func _physics_process(delta: float) -> void:
	if is_alive:
		manage_movement()
		manage_attacking()
	else:
		animated_sprite.play("Death")
		velocity.x = 0
		velocity.y += 30
	move_and_slide()

func manage_movement():
	# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * get_physics_process_delta_time()

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
			sword.set_flip_h(false)
			sword.position = Vector2(swordPositionX, swordPositionY)
		elif direction < 0:
			animated_sprite.flip_h = true
			sword.set_flip_h(true)
			sword.position = Vector2(swordPositionX * -1, swordPositionY)
			
		if direction:
			animated_sprite.play("Run")
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			

func manage_attacking():
	#if Input.is_mouse_button_pressed():
		pass
