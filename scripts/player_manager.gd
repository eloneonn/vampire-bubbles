extends Node

var max_health: float = 100.0
var experience: float = 0.0
var current_experience: float = 0.0
var kill_count: int = 0
var level: int = 1
var upgrades: Array[Enums.Upgrade] = []
var next_level = 25
var next_level_absolute = 25 # This should be same as above in the start
var next_level_modifier = 1.5

signal xp_changed(value:float, max: float)
signal received_upgrade(upgrade: Enums.Upgrade)
signal level_up(level: int)

func add_experience(amount: float) -> void:
	experience += amount
	current_experience += amount
	
	if experience >= next_level:
		level += 1
		next_level_absolute = next_level_absolute * next_level_modifier
		next_level += next_level_absolute
		await get_tree().create_timer(0.2).timeout
		level_up.emit(level)
		current_experience = 0.0
	
	xp_changed.emit(current_experience, next_level_absolute)

func add_kill(amount: int) -> void:
	kill_count += amount

func reset_stats() -> void:
	max_health = 100
	experience = 0
	kill_count = 0
	next_level = 25
	next_level_absolute = 25
	level = 1
	upgrades = []
	
func add_upgrade(upgrade: Enums.Upgrade) -> void:
	received_upgrade.emit(upgrade)
	upgrades.append(upgrade)

func has_upgrade(upgrade: Enums.Upgrade) -> bool:
	return upgrades.find(upgrade) != -1
