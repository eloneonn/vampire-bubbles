extends Node

var max_health: float = 100.0
var experience: float = 0.0
var kill_count: int = 0
var level: int = 1
var upgrades: Array[Enums.Upgrade] = []
var next_level = 100
var next_level_modifier = 1.05

signal xp_changed(value:float)
signal received_upgrade(upgrade: Enums.Upgrade)
signal level_up(level: int)

func add_experience(amount: float) -> void:
	experience += amount
	xp_changed.emit(experience)
	
	if experience >= next_level:
		level += 1
		next_level += next_level * next_level_modifier
		await get_tree().create_timer(0.2).timeout
		level_up.emit(level)

func add_kill(amount: int) -> void:
	kill_count += amount

func reset_stats() -> void:
	max_health = 100
	experience = 0
	kill_count = 0
	
func add_upgrade(upgrade: Enums.Upgrade) -> void:
	received_upgrade.emit(upgrade)
	upgrades.append(upgrade)

func has_upgrade(upgrade: Enums.Upgrade) -> bool:
	return upgrades.find(upgrade) != -1
