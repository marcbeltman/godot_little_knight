extends CharacterBody2D

# Declaratie van signalen
signal player_knight_died(body)


const SPEED = 130.0
const JUMP_POWER = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 900

# gevechtsmodus
var weapon_equip: bool

# aanval modus
#var current_attack: bool

var health = 100
var health_max = 100
var health_min = 0
var can_take_damage: bool
var dead: bool

# var zodat niet te vaak op spacebar attack kan worden gedrukt
var can_attack = true

@onready var animated_sprite = $AnimatedSprite2D
@onready var jump_sound = $jumpSound
@onready var sword_sound = $swordSound
@onready var hurt_sound = $hurtSound

@onready var deal_damage_zone = $DealDamageZone

func _ready():
		# player naar GameData 
	GameData.playerBody = self 
	print("Player in GameData:", GameData.playerBody)
	
	print("Player in Player", self)
	
	
	dead = false 
	can_take_damage = true 
	weapon_equip = GameData.weapon_equip
	# attack functionality
	#current_attack = false
	
	# connectie om te vaak clicken op spaceba attack te voorkomen
	$attack_cooldown_timer.connect("timeout", Callable(self, "_on_attack_cooldown_timeout"))

	# Verbind de signalen met de juiste functies uit Heath_system en Level_Manager
	#var health_system = get_node("/root/Game/GameManager/Health_System")
	# chek aanwezigheid
	#if health_system:
		# Haal de nodige functie op uit health_system
		#health_system.connect("player_knight_died", Callable(health_system, "player_die"))
	#else:
		#print("Player: Health_System not found")






	# nodig voor toggle_damage_collisions()
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	damage_zone_collision.disabled = true


# functie om het te vaak klikken te voorkomen
func _on_attack_cooldown_timeout():
	can_attack = true 


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
	GameData.playerDamageZone = deal_damage_zone
	
	
	
	
	# Handle attack
	if weapon_equip:
		if Input.is_action_just_pressed("attack") and is_on_floor() and can_attack:
			print("player attack")
			# var om te vaak spacebar te klikken voorkomen
			can_attack = false
			# Start de cooldown-timer
			$attack_cooldown_timer.start()
			#current_attack = true
			sword_sound.play()
			animated_sprite.play("attack")
			toggle_damage_collisions()
			set_damage()


	# Get the imput direction: -1, 0, 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
		deal_damage_zone.scale.x = 1
	elif direction < 0:
		animated_sprite.flip_h = true
		deal_damage_zone.scale.x = -1
	
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
		
	# check of de player geraakt wordt
	check_hitbox()
	

	move_and_slide()
	
	
# attack functionality
func toggle_damage_collisions():
	var damage_zone_collision = deal_damage_zone.get_node("CollisionShape2D")
	# animatie frames / fps
	var wait_time = 0.6
	damage_zone_collision.disabled = false
	await get_tree().create_timer(wait_time).timeout
	damage_zone_collision.disabled = true
	
func set_damage():
	var current_damage_to_deal = 8
	GameData.playerDamageAmount = current_damage_to_deal
	
func check_hitbox():
	var hitbox_areas = $PlayerHitBox.get_overlapping_areas()
	var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() is BatEnemy:
			damage = GameData.batDamageAmount
			
		if can_take_damage:
			take_damage(damage)
			
func take_damage(damage):
	if damage != 0:
		if health > 0:
			health -= damage
			#var knockback_dir = position.direction_to(player.position) * -50
			#velocity = knockback_dir
			
			
			
			print("player health: ", health)
			if health <= 0:
				health = 0
				print("player died ", GameData.playerBody)
				# belangrijk: stop bij sterven de aanval van de bat enemy 
				GameData.is_bat_chase = false
				# verzenden signaal naar Health_System
				player_knight_died.emit(self)
				dead = true
			take_damage_cooldown(1.0)
		
func take_damage_cooldown(wait_time):
	hurt_sound.play()
	can_take_damage = false
	await get_tree().create_timer(wait_time).timeout
	
	can_take_damage = true
