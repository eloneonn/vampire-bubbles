class_name EnemySpawner extends Node

enum enemy_type {BASIC, SPLIT, ARMORED}

var basic = preload("res://scenes/bubble.tscn")
var iron = preload("res://scenes/iron_bubble.tscn")
<<<<<<< Updated upstream
var ghost = preload("res://scenes/ghost_bubble.tscn")
=======
var split = preload("res://scenes/splitting_buble.tscn")
var baby = preload("res://scenes/baby_bubble.tscn")

>>>>>>> Stashed changes
func spawn_enemy():
	var instance = split.instantiate()
	instance.position = get_parent().global_position
	get_tree().root.add_child(instance)
