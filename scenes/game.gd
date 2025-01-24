extends Node2D

@onready var label: Label = $Camera2D/HUD/MarginContainer/HBoxContainer/VBoxContainer/Lable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.start_game()
	pass # Replace with function body.
