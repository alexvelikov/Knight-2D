extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword: Area2D = $Sword
@onready var health_manager: HealthManager = $HealthManager
@onready var hitbox_manager: HitboxManager = $HitboxManager
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var health_bar: Control = $HealthBar

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -300.0
var is_alive:bool
const swordPositionX = 9
const swordPositionY = -9


func _ready() -> void:
	hitbox_manager.took_damage.connect(health_manager.take_damage)
	hitbox_manager.took_damage.connect(health_bar.reduce)
	health_manager.died.connect(manage_death)
	
	health_bar.update(health_manager.health, health_manager.max_health)

func _physics_process(delta: float) -> void:
	manage_movement()
	manage_attacking()
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
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		sword.attack()

func manage_death():
	animated_sprite.play("Death")
	velocity.x = 0
	velocity.y += 30
	collision_shape_2d.set_deferred("disabled", true)
	Engine.time_scale = 0.5
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()
	collision_shape_2d.set_deferred("disabled", false)
	Engine.time_scale = 1
