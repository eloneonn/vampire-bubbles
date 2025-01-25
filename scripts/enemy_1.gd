extends CharacterBody2D

@export var player: NodePath
@export var orbit_radius = 100.0
@export var orbit_speed = 3.0
@onready var timer: Timer = $Timer

var orbit_modifier = 0
var orbit_increasing = true

var angle = 0.0
var SPEED = 1200

func _physics_process(delta):
	if GameManager.two_player_game:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		velocity = direction * SPEED
		
		move_and_slide()

	elif player:
		var player_node = get_node(player)
		angle += orbit_speed * delta
		var offset = Vector2(cos(angle), sin(angle)) * (orbit_radius + orbit_modifier)
		global_position = player_node.global_position + offset
		if orbit_modifier < 100 and orbit_increasing == true:
			orbit_modifier += 5
			if orbit_modifier >= 100:
				orbit_increasing = false
				
		if orbit_modifier > -100 and orbit_increasing == false:
			orbit_modifier -= 5
			if orbit_modifier <= -100:
				orbit_increasing = true

		
