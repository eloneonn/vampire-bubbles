extends CharacterBody2D

@onready var bubble: CharacterBody2D = $"."
@onready var player: CharacterBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var poppingFX = preload("res://scenes/death_particle.tscn")

const pop_sound = preload("res://assets/sfx/bubble4.wav")

const SPEED = 400.0

@export var update_interval: float = 0.5  # Time in seconds between AI updates
var ai_timer: float = 0.0

func _ready():
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta: float) -> void:
	ai_timer += delta
	if ai_timer >= update_interval:
		update_direction()
		ai_timer = 0.0
	move_and_slide()

func update_direction() -> void:
	if player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED

func _on_health_health_depleted() -> void:
	var random_pitch = randf_range(GameManager.pitch_MIN, GameManager.pitch_MAX)
	audio_stream_player_2d.pitch_scale = random_pitch
	audio_stream_player_2d.stream = pop_sound
	audio_stream_player_2d.play()
	
	PlayerManager.add_experience(GameManager.baby_bubble_xp)
	PlayerManager.add_kill(1)
	
	#popping effect
	var pop = poppingFX.instantiate()
	get_tree().root.add_child(pop)
	pop.global_position = self.global_position
	pop.emitting = true
	

	queue_free()
