class_name PlayerCamera extends Camera2D

@export var strength: float = 30.0
@export var shake_fade:float = 5.0

var rng = RandomNumberGenerator.new()

var shake_strength = 0.0

func apply_shake():
	shake_strength = strength

func _process(delta: float) -> void:
	if shake_strength > 0.0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
	
	offset = random_offset()

func random_offset():
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))
