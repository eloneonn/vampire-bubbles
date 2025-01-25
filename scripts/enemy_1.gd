extends CharacterBody2D

@export var player: NodePath
@export var base_orbit_radius = 1000.0
@export var orbit_speed = 3.0
@export var radius_variation_amplitude = 50.0
@export var radius_variation_speed = 1.0
@export var direction_change_interval = 5.0  # Time in seconds between potential direction changes
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var angle = 0.0
var orbit_direction = 1  # 1 for clockwise, -1 for counter-clockwise
var time_since_last_direction_change = 0.0
var SPEED = 1200

func _physics_process(delta):
	if GameManager.two_player_game:
		var mouse_pos = get_global_mouse_position()
		var direction = (mouse_pos - global_position).normalized()
		velocity = direction * SPEED
		
		if velocity.x > 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false
		
		move_and_slide()

	elif player:
		var player_node = get_node(player)
		angle += orbit_speed * delta * orbit_direction

		# Calculate dynamic orbit radius using a sine wave
		var dynamic_radius = base_orbit_radius + sin(Time.get_ticks_msec() / 1000.0 * radius_variation_speed) * radius_variation_amplitude

		var offset = Vector2(cos(angle), sin(angle)) * dynamic_radius
		global_position = player_node.global_position + offset
		
		if offset.x > 0:
			animated_sprite.flip_h = true
		else:
			animated_sprite.flip_h = false

		# Update time and potentially change orbit direction
		time_since_last_direction_change += delta
		if time_since_last_direction_change >= direction_change_interval:
			if randi() % 2 == 0:
				orbit_direction *= -1  # Change direction
			time_since_last_direction_change = 0.0
		
