class_name Health extends Node2D

@export var MAX_HEALTH: float = 100
@onready var health: float = MAX_HEALTH
var damage_indicator = preload("res://scenes/DamageIndicator.tscn")

signal health_depleted
signal lost_health(amount: float)

func damage(attack: Attack) -> void:
	lost_health.emit(attack.damage)
	
	var dmg_inst: DamageIndicator = damage_indicator.instantiate()
	var dmg_pos = global_position
	dmg_pos.y -= 400
	dmg_inst.global_position = dmg_pos
	dmg_inst.damage = attack.damage
	
	add_child(dmg_inst)

	health -= attack.damage
	if health <= 0:
		health_depleted.emit()
