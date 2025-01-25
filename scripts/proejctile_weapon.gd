class_name Projectile_Weapon extends Node2D

@export var weapon_type: WeaponType = WeaponType.new()
@onready var timer: Timer = Timer.new()
@export var enabled = false

var amount_of_projectiles: int = 1
var rate_of_fire: float = 0.2
var furball = preload("res://scenes/furball.tscn")
var direction: Vector2
var damage: float = 10
@onready var speed = weapon_type.speed

signal attack(weapon_type: WeaponType)

func _ready() -> void:
	add_child(timer)
	timer.wait_time = speed
	timer.one_shot = false
	timer.connect("timeout", perform_attack)
	timer.start()

func _process(delta: float) -> void:
	var random_angle = randf_range(0.0, 360.0)
	var random_angle_radians = deg_to_rad(random_angle)
	direction = Vector2(cos(random_angle_radians), sin(random_angle_radians))

func perform_attack() -> void:
	if !enabled:
		return
	
	for n in amount_of_projectiles:
		var instance: Furball = furball.instantiate()
		instance.damage = damage
		instance.position = global_position
		instance.direction = direction
		instance.rotation = direction.angle()
		get_tree().root.add_child.call_deferred(instance)
		await get_tree().create_timer(rate_of_fire).timeout
