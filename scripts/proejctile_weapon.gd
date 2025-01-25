class_name Projectile_Weapon extends Node2D

@export var weapon_type: WeaponType = WeaponType.new()
@export var hitbox: Hitbox
@onready var timer: Timer = Timer.new()
var furball = preload("res://scenes/furball.tscn")
var direction: Vector2
var player_pos: Vector2

signal attack(weapon_type: WeaponType)

func _ready() -> void:
	add_child(timer)
	timer.wait_time = weapon_type.speed 
	timer.one_shot = false
	timer.connect("timeout", perform_attack)
	timer.start()

func _process(delta: float) -> void:
	# We can update direction here based on player's weapon rotation
	#direction = Vector2(cos(rotation), sin(rotation))  # Convert rotation to direction vector
	direction = Vector2(randf_range(-1,1),randf_range(-1,1))

# Called every x seconds
func perform_attack() -> void:
	var instance = furball.instantiate()
	instance.position = global_position
	instance.direction = direction
	instance.rotation = direction.angle()
	get_tree().root.add_child(instance)
