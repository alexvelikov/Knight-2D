extends Node2D   # Node2D, so it has a position
class_name LootDropper

@export var loot: PackedScene

func drop():
	print("drop started")
	var container := get_tree().get_first_node_in_group("coin_container")
	if container == null:
		push_warning("No node in group 'coin_container'")
		return
	var coin := loot.instantiate()
	print("coin created")
	container.add_child(coin)
	coin.global_position = global_position
	print("coin placed")
