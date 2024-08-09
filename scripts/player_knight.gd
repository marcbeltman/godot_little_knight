extends CharacterBody2D


const SPEED = 130.0
const JUMP_POWER = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 900

# gevechtsmodus
var weapon_equip: bool

# aanval modus
var current_attack: bool


@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $jumpSound
@onready var sword_sound = $swordSound

func _ready():
	weapon_equip = GameData.weapon_equip
	#current_attack = false





func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sound.play()
		velocity.y = JUMP_POWER
		
	# Check of de player in gevechtsmodus moet gaan
	weapon_equip = GameData.weapon_equip
		
	# Handle attack
	if weapon_equip:
		if Input.is_action_just_pressed("attack") and is_on_floor():
			print("player attack")
			sword_sound.play()
			animated_sprite.play("attack")


	# Get the imput direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#play animations
	if is_on_floor():
		if animated_sprite.animation != "attack" or not animated_sprite.is_playing():
			if direction == 0 and !weapon_equip:
				animated_sprite.play("idle")
			elif direction == 0 and weapon_equip:
				animated_sprite.play("attack_idle")
			elif direction != 0:
				animated_sprite.play("run")
	else: 
		animated_sprite.play("jump")

		
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

