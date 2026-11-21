extends Node2D

@onready var ground_check_right: RayCast2D = $GroundCheckers/GroundCheckRight
@onready var ground_check_left: RayCast2D = $GroundCheckers/GroundCheckLeft
@onready var health_manager: HealthManager = $HealthManager
@onready var hurtbox_manager: HurtboxManager = $HurtboxManager
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_bar: Control = $HealthBar
@onready var healing_manager: Node = $HealingManager
@onready var loot_dropper: LootDropper = $LootDropper
@onready var movement_limits: Node2D = $MovementLimits
@onready var player_detection_area: Area2D = $PlayerDetectionArea

var damage: float
var direction := 1
@export var speed := 90.0

var target_in_range: Node2D = null


func _ready() -> void:
	hurtbox_manager.took_damage.connect(take_damage)
	health_manager.died.connect(manage_death)
	health_bar.update(health_manager.health, health_manager.max_health)
	player_detection_area.area_entered.connect(_on_area_entered)
	player_detection_area.area_exited.connect(_on_area_exited)

func take_damage(amount):
	health_manager.take_damage(amount)
	health_bar.reduce(amount)
	healing_manager.start_healing_cooldown()

func set_flip_h():
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

func _on_area_entered(body: Area2D) -> void:
	if body.is_in_group("player"):
		target_in_range = body

func _on_area_exited(body: Area2D) -> void:
	if body == target_in_range:
		target_in_range = null

func below_crit_health() -> bool:
	if health_manager.health <= health_manager.crit_health:
		return true
	return false

func idle() -> void:
	position.x += direction * -1
	pass

func step_towards_target():
	if floor_ends():
		idle()
	else:
		var follow_direction = sign(target_in_range.global_position.x - global_position.x)
		position.x += follow_direction * speed * get_physics_process_delta_time()
		direction = follow_direction
		set_flip_h()

func flee_from_target():
	if floor_ends():
		idle()
	else:
		var follow_direction = sign(global_position.x - target_in_range.global_position.x)
		position.x += follow_direction * speed * get_physics_process_delta_time()
		direction = follow_direction
		set_flip_h()

func patrol() -> void:
	if floor_ends():
		direction *= -1
	position.x += direction * speed * get_physics_process_delta_time()
	set_flip_h()
	
func floor_ends() -> bool:
	if movement_limits.all_raycasters_trigered():
		return false
	return true

func manage_death():
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	await get_tree().create_timer(0.5).timeout
	loot_dropper.drop()
	queue_free()
