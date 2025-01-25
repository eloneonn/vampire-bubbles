class_name EnemySpawner extends Node

enum enemy_type {BASIC, FAST, ARMORED}

var basic = preload("res://scenes/bubble.tscn")
var iron = preload("res://scenes/iron_bubble.tscn")

func spawn_enemy():
	var instance = iron.instantiate()
	instance.position = get_parent().global_position
	get_tree().root.add_child(instance)
