extends Node2D

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var health_manager: HealthManager = $HealthManager
@onready var hitbox_manager: HitboxManager = $HitboxManager

@export var speed := 60.0
@export var damage := 10.0
var direction = 1


func _ready() -> void:
	hitbox_manager.took_damage.connect(health_manager.take_damage)
	health_manager.died.connect(manage_death)

func _process(delta: float) -> void:
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
	queue_free()
