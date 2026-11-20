extends Node2D

@onready var hitbox_manager: HitboxManager = $HitboxManager
@onready var health_manager: HealthManager = $HealthManager
@onready var health_bar: HealthBar = $HealthBar
@onready var healing_manager: Node = $HealingManager
@onready var loot_dropper: LootDropper = $LootDropper
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var direction := 1
@export var speed := 90.0
@export var damage := 10.0
var target_in_range: Node2D


func _ready() -> void:
	hitbox_manager.took_damage.connect(take_damage)
	health_manager.died.connect(manage_death)
	health_bar.update(health_manager.health, health_manager.max_health)

func take_damage(amount: float):
	health_manager.take_damage(amount)
	health_bar.reduce(amount)
	healing_manager.start_healing_cooldown()

func set_flip_h(direction: float):
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

func below_crit_health() -> bool:
	if health_manager.health <= health_manager.crit_health:
		return true
	return false

func idle() -> void:
	position.x += direction * -1
	pass

func step_towards_target():
	if reaching_limit():
		idle()
	else:
		var follow_direction = sign(target_in_range.global_position.x - global_position.x)
		position.x += follow_direction * speed * get_physics_process_delta_time()
		direction = follow_direction
		set_flip_h(direction)

func flee_from_target():
	if reaching_limit():
		idle()
	else:
		var follow_direction = sign(global_position.x - target_in_range.global_position.x)
		position.x += follow_direction * speed * get_physics_process_delta_time()
		direction = follow_direction
		set_flip_h(direction)

func patrol() -> void:
	if reaching_limit():
		direction *= -1
	position.x += direction * speed * get_physics_process_delta_time()
	set_flip_h(direction)
	
func reaching_limit() -> bool:
	if ground_check_left .is_colliding() || ground_check_right.is_colliding():
		return false
	return true

func manage_death():
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	await get_tree().create_timer(0.5).timeout
	loot_dropper.drop()
	queue_free()
