extends CharacterBody2D

@onready var bubble: CharacterBody2D = $"."
@onready var player: CharacterBody2D

const SPEED = 100.0
const WAVE_AMPLITUDE = 300.0  # How far the enemy sways
const WAVE_FREQUENCY = 4.0  # How fast it sways
var time_elapsed = 0.0

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	if player:
		time_elapsed += delta
		var player_position = player.global_position

		# Base movement direction
		var direction = (player_position - global_position).normalized()

		# Apply sinusoidal wave movement to the perpendicular direction
		var perpendicular = Vector2(-direction.y, direction.x)  # Perpendicular vector
		var wave_offset = perpendicular * sin(time_elapsed * WAVE_FREQUENCY) * WAVE_AMPLITUDE

		velocity = (direction * SPEED) + wave_offset
		move_and_slide()

func _on_health_health_depleted() -> void:
	PlayerManager.add_experience(1)
	PlayerManager.add_kill(1)
	queue_free()
