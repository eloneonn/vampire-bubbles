extends CharacterBody2D

@export var player: NodePath

const SPEED = 200.0

func _physics_process(delta: float) -> void:
	var player_node: CharacterBody2D = get_node(player)
	
	if player_node:
		var direction = (player_node.global_position - global_position).normalized()
		velocity = direction * SPEED
		
		move_and_slide()

func _on_health_health_depleted() -> void:
	queue_free()
