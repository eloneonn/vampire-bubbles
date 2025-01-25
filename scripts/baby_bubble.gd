extends CharacterBody2D

@onready var bubble: CharacterBody2D = $"."
@onready var player: CharacterBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const pop_sound = preload("res://assets/sfx/bubble4.wav")

const SPEED = 100.0

func _ready():
	
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	if player:
		var player_position = player.global_position
		
		var direction = (player_position - global_position).normalized()
		velocity = direction * SPEED
		
		move_and_slide()

func _on_health_health_depleted() -> void:
	audio_stream_player_2d.stream = pop_sound
	audio_stream_player_2d.play()
	
	PlayerManager.add_experience(1)
	PlayerManager.add_kill(1)
	queue_free()
