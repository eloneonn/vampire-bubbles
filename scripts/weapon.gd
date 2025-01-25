class_name Weapon extends Node2D

@export var weapon_type: WeaponType
@export var hitbox: Hitbox
@onready var timer: Timer = Timer.new()
@export var enabled: bool

@onready var damage: float = weapon_type.damage
@onready var speed: float = weapon_type.speed

signal attack()

func _ready() -> void:	
	timer.wait_time = speed 
	add_child(timer)
	timer.one_shot = false
	timer.connect("timeout", perform_attack)
	timer.start()
	
func _process(delta):
	timer.wait_time = speed 
	hitbox.damage = damage

func perform_attack() -> void:
	if !enabled:
		return
	
	attack.emit()
	hitbox.enable_for(weapon_type.duration)

func increase_size():
	pass
