extends Label

@onready var health: Health = $"../../../Health"



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = str(health.health)
