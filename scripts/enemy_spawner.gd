class_name EnemySpawner extends Node2D

enum enemy_type {BASIC, SPLIT, ARMORED}

var basic = preload("res://scenes/bubble.tscn")
var iron = preload("res://scenes/iron_bubble.tscn")
var ghost = preload("res://scenes/ghost_bubble.tscn")
var split = preload("res://scenes/splitting_buble.tscn")

@onready var timer: Timer = Timer.new()
@export var spawn_interval: float = 0.5

func _ready():
	add_child(timer)
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.connect("timeout", spawn_enemy)
	timer.start()

func start_game():
	timer.one_shot = true
	timer.timeout.connect(self._on_timer_timeout)
	timer.start()


func spawn_enemy():
	var enemies: Array = [basic]
	
	if GameManager.get_progress() > 20:
		enemies.append(iron)
		
	if GameManager.get_progress() > 40:
		enemies.append(ghost)
		
	if GameManager.get_progress() > 60:
		enemies.append(split)
	
	var enemy = enemies.pick_random()
	
	var instance = enemy.instantiate()
	
	instance.position = global_position
	get_tree().root.add_child(instance)
