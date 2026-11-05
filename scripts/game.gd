extends Node2D

@onready var game_manager: Node = $GameManager
@onready var hud: CanvasLayer = $HUD
@onready var killzone: Area2D = $Killzone
@onready var player: CharacterBody2D = $Player

var score := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	manage_signal_connections()
	hud.update_score(0)

func _coin_collected():
	score += 1
	hud.update_score(score)

func manage_signal_connections():
	for coin in $Coins.get_children():
		coin.collected.connect(_coin_collected)
