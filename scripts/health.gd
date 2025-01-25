class_name Health extends Node

@export var MAX_HEALTH: float = 100
@onready var health: float = MAX_HEALTH

signal health_depleted
signal lost_health(amount: float)

func damage(attack: Attack) -> void:
	lost_health.emit(attack.damage)
	
	health -= attack.damage
	if health <= 0:
		health_depleted.emit()
