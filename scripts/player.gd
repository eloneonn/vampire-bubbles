extends CharacterBody2D

const speed = 300.0
@onready var health: Health = $Health

func _ready():
	health.MAX_HEALTH = PlayerManager.max_health

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("left", "right", "up", "down")
	velocity = input_vector * speed
	move_and_slide()

func _on_health_health_depleted() -> void:
	queue_free()
