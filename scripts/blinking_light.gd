extends PointLight2D

# Speed of the fade effect
@export var fade_speed : float = 2.0
# Maximum and minimum energy values for the fade effect
@export var max_energy : float = 1.8
@export var min_energy : float = 0.0

# Time accumulator for calculating the sine wave
var time : float = 0.0

func _process(delta):
	# Accumulate time with delta
	time += delta * fade_speed
	# Adjust the energy property of the PointLight2D to create the fade effect
	self.energy = min_energy + (max_energy - min_energy) * abs(sin(time))
