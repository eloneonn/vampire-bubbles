class_name DamageIndicator extends Node2D

var damage = 0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var label: Label = $Label

func _ready() -> void:
	label.text = "%.1f" % (damage * 10)
	animation_player.play("fade")
