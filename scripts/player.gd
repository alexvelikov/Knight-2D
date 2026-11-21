extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sword: Area2D = $Sword
@onready var health_manager: HealthManager = $HealthManager
@onready var hurtbox_manager: HurtboxManager = $HurtboxManager
@onready var collision_shape_2d: CollisionShape2D = $PlayerShape
@onready var health_bar: Control = $HealthBar
@onready var healing_manager: Node = $HealingManager
@onready var landing_dust: GPUParticles2D = $LandingDust
@onready var running_dust: GPUParticles2D = $RunningDust

@export var SPEED := 150.0
@export var JUMP_VELOCITY := -300.0
const swordPositionX = 9
const swordPositionY = -9

const NORMAL_SCALE = Vector2(1.0, 1.0)
const LAND_SCALE = Vector2(1.2, 0.8)

const MAX_STRETCH = 0.12
const STRETCH_SPEED = 600.0
const RECOVERY_SPEED = 12.0

var landing_tween: Tween


func _ready() -> void:
	hurtbox_manager.took_damage.connect(take_damage)
	health_manager.died.connect(manage_death)
	
	health_bar.update(health_manager.health, health_manager.max_health)

func take_damage(amount):
	health_manager.take_damage(amount)
	health_bar.reduce(amount)
	healing_manager.start_healing_cooldown()

func _physics_process(delta: float) -> void:
	manage_movement(delta)
	manage_attacking()

func manage_movement(delta: float):
	var was_on_floor = is_on_floor()
	if not is_on_floor():
		velocity += get_gravity() * get_physics_process_delta_time()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		animated_sprite.play("Jump")
		velocity.y = JUMP_VELOCITY

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

	move_and_slide()
	
	manage_particles(was_on_floor)
	update_squash_stretch(delta)

func manage_particles(was_on_floor: bool):
	if velocity.x > 0:
		running_dust.position.x = -8
	elif velocity.x < 0:
		running_dust.position.x = 8
	if not was_on_floor and is_on_floor():
		landing_dust.restart()
	var is_running = is_on_floor() and abs(velocity.x) > 10.0
	running_dust.emitting = is_running

func update_squash_stretch(delta: float) -> void:
	var target_scale = NORMAL_SCALE

	if not is_on_floor():
		var stretch = clamp(
			abs(velocity.y) / STRETCH_SPEED, 
			0.0, 
			MAX_STRETCH)
		
		target_scale = Vector2(1.0 - stretch,1.0 + stretch)
	
	animated_sprite.scale = animated_sprite.scale.lerp(
		target_scale,
		min(RECOVERY_SPEED * delta, 1.0)
	)

func manage_attacking():
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_SPACE):
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
