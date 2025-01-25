extends CharacterBody2D

@onready var bubble: CharacterBody2D = $"."
@onready var player: CharacterBody2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const pop_sound = preload("res://assets/sfx/bubble5.wav")

const SPEED = 100.0

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
	PlayerManager.add_experience(1)
	PlayerManager.add_kill(1)
	spawn_baby()
	queue_free()
	
	

func spawn_baby():
	var random_pitch = randf_range(GameManager.pitch_MIN, GameManager.pitch_MAX)
	audio_stream_player_2d.pitch_scale = random_pitch
	audio_stream_player_2d.stream = pop_sound
	audio_stream_player_2d.play()
	
	var baby = preload("res://scenes/baby_bubble.tscn")
	var offset_distance = 20
	#mini bubble 1
	var instance_1 = baby.instantiate()
	instance_1.position = global_position + Vector2(offset_distance, 0)
	get_tree().root.add_child.call_deferred(instance_1)
	#mini bubble 2
	var instance_2 = baby.instantiate()
	instance_2.position = global_position - Vector2(offset_distance, 0)
	get_tree().root.add_child.call_deferred(instance_2)
	
	
