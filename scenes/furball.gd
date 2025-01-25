extends Node2D

@export var speed: float = 800  # Speed of the projectile
var direction: Vector2  # Direction of the projectile's movement

# Called when the node enters the scene tree for the first time.
func _ready():
	# Assuming the direction is set when the projectile is fired (through some external script)
	direction = global_position.normalized()  # You would set the direction based on the firing logic

# Called every frame
func _process(delta: float) -> void:
	# Move the projectile in the direction it's fired
	position += direction * speed * delta
	
	# Check if the projectile is out of the screen bounds
	#if not get_viewport_rect().has_point(position):
	#	queue_free()  # Delete the projectile if it goes off-screen
