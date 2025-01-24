class_name Hitbox extends Area2D

func _ready() -> void:
	self.connect("area_entered", on_enter)

func on_enter(area: Area2D):
	if area is not Hurtbox:
		return
	
	var hurtbox: Hurtbox = area
	
	var attack = Attack.new()
	attack.damage = 10
	
	hurtbox.damage(attack)
