extends CharacterBody2D

# Exported variables to set in the Inspector
@export var speed: float = 100.0
@export var left_limit_node: NodePath
@export var right_limit_node: NodePath

# Internal variables
var direction: int = 1  # 1 is moving to the right, -1 is moving to the left
var left_limit: float
var right_limit: float
var tolerance: float = 0.5  # Small value to avoid jitter

func _ready():
	# Get the global positions of the left and right limits
	left_limit = get_node(left_limit_node).global_position.x
	right_limit = get_node(right_limit_node).global_position.x
	
	# Ensure the platform starts within the limits
	global_position.x = clamp(global_position.x, left_limit, right_limit)

func _physics_process(delta):
	# Calculate the movement vector
	velocity = Vector2(speed * direction, 0)
	
	# Move the platform
	move_and_slide()
	
	# Check if the platform needs to change direction
	if global_position.x > right_limit - tolerance:
		direction = -1  # Move to the left
	elif global_position.x < left_limit + tolerance:
		direction = 1  # Move to the right
