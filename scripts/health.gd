class_name Health extends Node

@export var MAX_HEALTH: float = 100
@onready var health: float = MAX_HEALTH

var damage_indicator = load("res://scenes/DamageIndicator.tscn")

signal health_depleted
signal lost_health

func damage(attack: Attack) -> void:
	
	lost_health.emit()
	
	var dmg_inst: DamageIndicator = damage_indicator.instantiate()
	dmg_inst.global_position = get_parent().global_position
	dmg_inst.damage = attack.damage
	
	get_tree().root.add_child(dmg_inst)
	
	health -= attack.damage
	if health <= 0:
		health_depleted.emit()
