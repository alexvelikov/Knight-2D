extends Node2D

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_manager: HealthManager = $HealthManager
@onready var hurtbox_manager: HurtboxManager = $HurtboxManager
@onready var health_bar: Control = $HealthBar
@onready var loot_dropper: LootDropper = $LootDropper

@export var speed := 60.0
@export var damage := 10.0
var alive := true
var direction = 1


func _ready() -> void:
	hurtbox_manager.took_damage.connect(health_manager.take_damage)
	hurtbox_manager.took_damage.connect(health_bar.reduce)
	health_manager.died.connect(manage_death)
	
	health_bar.update(health_manager.health, health_manager.max_health)

func _process(delta: float) -> void:
	if alive:
		move(delta)
	
func move(delta: float):
	if not ray_cast_left.is_colliding():
		animated_sprite.flip_h = false;
		direction = 1
	if not ray_cast_right.is_colliding():
		animated_sprite.flip_h = true;
		direction = -1
	position.x += speed * delta * direction
	
func manage_death():
	alive = false
	animated_sprite.play("Death")
	await animated_sprite.animation_finished
	await get_tree().create_timer(0.5).timeout
	loot_dropper.drop()
	queue_free()
