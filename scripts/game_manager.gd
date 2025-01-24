extends Node

var timer: Timer

func start_game():
	# Create a new Timer instance
	timer = Timer.new()
	# Set the timer's wait time to 60 seconds
	timer.wait_time = 60
	# Set the timer to one-shot mode
	timer.one_shot = true
	# Add the timer as a child of the current node
	add_child(timer)
	# Connect the timeout signal to a function
	timer.timeout.connect(self._on_timer_timeout)	# Start the timer
	timer.start()

func get_time():
	if timer and timer.time_left > 0:
		# Calculate the remaining time
		var time_left = int(timer.time_left)
		var minutes = time_left / 60
		var seconds = time_left % 60
		# Update the label text
		return "%02d:%02d" % [minutes, seconds]

func _on_timer_timeout():
	pass
	# Perform any additional actions needed when the timer finishes
