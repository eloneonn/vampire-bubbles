class_name DamageIndicator extends Node2D

var damage = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

func _ready() -> void:
	label.text = str(damage)
	animation_player.play("fade")
