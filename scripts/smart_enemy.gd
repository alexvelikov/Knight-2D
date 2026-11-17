extends Node2D

@onready var ground_check_right: RayCast2D = $GroundCheckers/GroundCheckRight
@onready var ground_check_left: RayCast2D = $GroundCheckers/GroundCheckLeft
@onready var health_manager: HealthManager = $HealthManager
@onready var hitbox_manager: HitboxManager = $HitboxManager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: Control = $HealthBar

var direction := 1
@export var speed := 90.0
@export var damage := 10.0
var target_in_range: Node2D = null

#Called when the node enters the scene tree for the first time.

func _ready() -> void:
	$PlayerDetectionArea.body_entered.connect(_on_body_entered)
	$PlayerDetectionArea.body_exited.connect(_on_body_exited)
	hitbox_manager.took_damage.connect(health_manager.take_damage)
	hitbox_manager.took_damage.connect(health_manager.take_damage)
	hitbox_manager.took_damage.connect(health_bar.reduce)
	health_manager.died.connect(manage_death)
	health_bar.update(health_manager.health, health_manager.max_health)

func set_flip_h(direction: float):
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target_in_range = body

func _on_body_exited(body: Node2D) -> void:
	if body == target_in_range:
		target_in_range = null

func below_crit_health() -> bool:
	if health_manager.health <= health_manager.crit_health:
		return true
	return false

func idle() -> void:
	pass

func step_towards_target():
	if floor_ends():
		idle()
	else:
		var follow_direction = sign(target_in_range.global_position.x - global_position.x)
		position.x += follow_direction * speed * get_physics_process_delta_time()
		direction = follow_direction
		set_flip_h(direction)

func flee_from_target():
	if floor_ends():
		idle()
	else:
		var follow_direction = sign(global_position.x - target_in_range.global_position.x)
		position.x += follow_direction * speed * get_physics_process_delta_time()
		direction = follow_direction
		set_flip_h(direction)

func patrol() -> void:
	if floor_ends():
		direction *= -1
	position.x += direction * speed * get_physics_process_delta_time()
	set_flip_h(direction)
	
func floor_ends() -> bool:
	if ground_check_left .is_colliding() || ground_check_right.is_colliding():
		return false
	return true

func manage_death():
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	await get_tree().create_timer(0.5).timeout
	queue_free()
