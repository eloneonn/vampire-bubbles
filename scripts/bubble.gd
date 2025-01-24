extends CharacterBody2D

@onready var bubble: CharacterBody2D = $"."

const SPEED = 200.0

func _physics_process(delta: float) -> void:
	var player = get_tree().get_nodes_in_group("player")[0]

	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
		
		move_and_slide()

func _on_health_health_depleted() -> void:
	queue_free()
