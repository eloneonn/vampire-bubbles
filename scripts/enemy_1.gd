extends CharacterBody2D

@export var player: NodePath
@export var orbit_radius = 100.0
@export var orbit_speed = 1.0
@onready var timer: Timer = $Timer
@onready var enemy_spawner: EnemySpawner = $EnemySpawner

@export var spawn_interval: float = 1.0
var angle = 0.0
var SPEED = 300

func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.one_shot = false
	timer.connect("timeout", spawn)
	timer.start()

func spawn():
	if enemy_spawner:
		enemy_spawner.spawn_enemy()

func _physics_process(delta):
	if GameManager.two_player_game:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		velocity = direction * SPEED
		
		move_and_slide()
		
		global_position = get_global_mouse_position()
	elif player:
		var player_node = get_node(player)
		angle += orbit_speed * delta
		var offset = Vector2(cos(angle), sin(angle)) * orbit_radius
		global_position = player_node.global_position + offset
