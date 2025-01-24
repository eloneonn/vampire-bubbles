class_name Hitbox extends Area2D

@export var hitbox: Area2D 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.connect("area_entered", on_enter)

func on_enter(area: Area2D):
	if area is not Hurtbox:
		return
	
	var hitbox: Hurtbox = area
	
	var attack = Attack.new()
	attack.damage = 10
	
	hitbox.damage(attack)
