extends CharacterBody2D

@export var player: NodePath

const SPEED = 200.0

func _physics_process(delta: float) -> void:
	var player_node: CharacterBody2D = get_node(player)

	if player_node:
		# Get direction vector to the player
		var direction = (player_node.global_position - global_position).normalized()
		# Move the enemy toward the player
		velocity = direction * SPEED
		
		move_and_slide()
