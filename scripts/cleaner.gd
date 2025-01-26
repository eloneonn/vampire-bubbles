class_name Cleaner extends Node2D

var body: CharacterBody2D
var enabled: bool = false
var screen_checker: VisibleOnScreenEnabler2D = VisibleOnScreenEnabler2D.new()

func _ready() -> void:
	var parent = get_parent()
	
	if parent is CharacterBody2D:
		body = parent
		enabled = true
		screen_checker.screen_exited.connect(on_screen_exit)
		add_child(screen_checker)

func on_screen_exit():
	await get_tree().create_timer(3).timeout
	if !screen_checker.is_on_screen():
		body.queue_free()
