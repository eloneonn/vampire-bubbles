class_name Weapon extends Node2D

@export var weapon_type: WeaponType = WeaponType.new()
@export var hitbox: Hitbox
@onready var timer: Timer = $Timer

signal attack(weapon_type: WeaponType)

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
	attack.emit(weapon_type)
	hitbox.enable_for(weapon_type.duration)
