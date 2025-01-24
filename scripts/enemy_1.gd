extends CharacterBody2D

@export var player: NodePath
@export var orbit_radius = 100.0
@export var orbit_speed = 1.0

var angle = 0.0

func _process(delta):
	if player:
		var player_node = get_node(player)
		angle += orbit_speed * delta
		var offset = Vector2(cos(angle), sin(angle)) * orbit_radius
		global_position = player_node.global_position + offset
	
