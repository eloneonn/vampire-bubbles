class_name Weapon extends Node

@export var weapon_type: WeaponType = WeaponType.new()
@onready var hitbox: Hitbox = $"../Hitbox"
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = weapon_type.speed 
	timer.one_shot = false
	timer.connect("timeout", perform_attack)
	timer.start()
	hitbox.damage = weapon_type.damage

func _process(delta: float) -> void:
	pass

# Called every x seconds
func perform_attack() -> void:
	hitbox.enable_for(weapon_type.duration)
