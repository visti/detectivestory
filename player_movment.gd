extends CharacterBody2D

# Constants
@export var SPEED: float = 100.0
@export var GRAVITY: float = 1000.0
@export var ACCELERATION: float = 600.0
@export var DECELERATION: float = 800.0
@export var MAX_JUMP_CHARGE: float = 1.0  # Max charge time in seconds
@export var MIN_JUMP_VELOCITY: float = -100.0  # Minimum jump force
@export var MAX_JUMP_VELOCITY: float = -300.0  # Maximum jump force when fully charged

# Variables
var is_charging_jump: bool = false  # Indicates if the player is charging a jump
var jump_charge_time: float = 0.0   # Accumulates the time the jump button is held

# Reference to the AnimatedSprite2D node
@onready var _animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Handle jump input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and not is_charging_jump:
		is_charging_jump = true
		jump_charge_time = 0.0
		_animated_sprite.play("jump")
		_animated_sprite.frame = 1  # Set to frame 1 (since frames start at 0)
		_animated_sprite.speed_scale = 0.0  # Pause the animation

	if is_charging_jump:
		# Increment the charge time up to the maximum
		jump_charge_time += delta
		if jump_charge_time > MAX_JUMP_CHARGE:
			jump_charge_time = MAX_JUMP_CHARGE

		# Prevent movement during charging
		velocity.x = 0
		velocity.y = 0

		# Keep the jump animation on frame 1
		_animated_sprite.frame = 1
		_animated_sprite.speed_scale = 0.0  # Ensure the animation is paused

		# Check if the jump button is released
		if Input.is_action_just_released("ui_accept"):
			is_charging_jump = false
			# Calculate the jump velocity based on charge time
			var charge_ratio = jump_charge_time / MAX_JUMP_CHARGE
			var jump_velocity = lerp(MIN_JUMP_VELOCITY, MAX_JUMP_VELOCITY, charge_ratio)
			velocity.y = jump_velocity

			# Resume the jump animation
			_animated_sprite.speed_scale = 1.0
			_animated_sprite.play("jump")  # Start playing the jump animation from current frame
	else:
		# Apply gravity if not on the floor
		if not is_on_floor():
			velocity.y += GRAVITY * delta
		else:
			velocity.y = 0  # Reset vertical velocity when on the floor

		# Handle horizontal movement
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			# Accelerate towards max speed
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)

			# Play the run animation if on the ground
			if is_on_floor():
				_animated_sprite.play("run")
				_animated_sprite.speed_scale = 1.0  # Ensure animation is playing

			# Flip the sprite based on direction
			_animated_sprite.flip_h = direction > 0  # Use your preferred flip logic
		else:
			# Decelerate to a stop
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)

			# Stop the animation when not moving and on the ground
			if is_on_floor():
				_animated_sprite.stop()

	# Apply movement
	move_and_slide()
