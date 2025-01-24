class_name Health extends Node

@export var MAX_HEALTH: float

@onready var health = MAX_HEALTH

func damage(attack: Attack) -> void:
	health -= attack.damage
