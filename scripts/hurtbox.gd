class_name Hurtbox extends Area2D

@export var health: Health

func damage(attack: Attack) -> void:
	health.damage(attack)
