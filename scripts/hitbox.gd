class_name Hitbox extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@export var permanent: bool = false
@export var damage: float = 10

func _ready() -> void:
	self.connect("area_entered", on_enter)
	if !permanent:
		collision_shape.disabled = true

func on_enter(area: Area2D):
	if area is not Hurtbox:
		return
	
	var hurtbox: Hurtbox = area
	var attack = Attack.new()
	attack.damage = damage
	
	hurtbox.damage(attack)

func enable_for(duration: float) -> void:
	if permanent:
		return
	
	collision_shape.disabled = false
	await get_tree().create_timer(duration).timeout
	collision_shape.disabled = true
