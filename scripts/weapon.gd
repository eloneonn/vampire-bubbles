class_name Weapon extends Node2D

@export var weapon_type: WeaponType
@export var hitbox: Hitbox
@onready var timer: Timer = Timer.new()
@export var enabled: bool

signal attack()

func _ready() -> void:
	timer.wait_time = weapon_type.speed 
	hitbox.damage = weapon_type.damage
	
	add_child(timer)
	timer.one_shot = false
	timer.connect("timeout", perform_attack)
	timer.start()

func perform_attack() -> void:
	if !enabled:
		return
	
	attack.emit()
	hitbox.enable_for(weapon_type.duration)

func increase_size():
	pass
