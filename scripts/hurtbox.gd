class_name Hurtbox extends Area2D

@export var health: Health
@export var enabled: bool = true

func damage(attack: Attack) -> void:
	health.damage(attack)
