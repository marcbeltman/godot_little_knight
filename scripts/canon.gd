extends StaticBody2D


#@export var player_path : NodePath
#var player : Node2D

@export var health := 80
@export var knockback_strength := 200.0  # De sterkte van de knockback
@export var knockback_duration := 1.0  # Hoe lang de knockback moet duren


@onready var Game = get_tree().get_root().get_node("Game")
@onready var projectile = load("res://scenes/canon_projectile.tscn")
@onready var cooldown_timer = $Cooldown
@onready var canon_sound = $CanonSound
@onready var canon_fire = $canon_fire
@onready var canon_gun = $canon_gun
@onready var canon_destroy = $canon_destroy

var player: CharacterBody2D
var canon_start_position: Vector2
var knockback_time_elapsed: float = 0.0  # Tijd die verstreken is sinds de knockback begon
var offset = Vector2(23,-3)

var health_max = health
var health_min = 0
var dead : bool = false
var taking_damage : bool = false
var damage_te_deal = 20 





# Called when the node enters the scene tree for the first time.
func _ready():
	print("KUTZOOI ", GameData.canon_can_shoot)
	# Sla de beginpositie op bij het laden van de scène
	canon_start_position = global_position
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_timeout"))
	#cooldown_timer.start()  # Start de timer als het niet automatisch gebeurt
	#shoot()
	z_index = 5
	#LAAT HET KANON BEGINNEN MET SCHIETEN MOET NAAR EEN AREA 2D!!!
	GameData.canon_can_shoot = false
	print("GameData.canon_can_shoot: ", GameData.canon_can_shoot)
	#if player_path:
		#player = get_node(player_path)
	#else:
		#print("CANON: Player path is not set!")
	
func shoot(): 
	print("canon-shoot")
	canon_fire.play()
	canon_sound.play()
	var instance = projectile.instantiate()
	#instance.dir = rotation
	instance.dir = $canon_gun/Marker_respawn.global_rotation
	instance.spawnPos = $canon_gun/Marker_respawn.global_position
	instance.spawnRot = rotation
	#instance.zdex = z_index -1
	
	Game.add_child.call_deferred(instance)
	apply_knockback()


func apply_knockback():
	# Bepaal de richting van de knockback (tegenovergesteld aan de richting van het schot)
	var knockback_direction = Vector2(-cos(rotation), -sin(rotation))	
	# Pas de knockback toe door de globale positie van het kanon te verplaatsen
	global_position += knockback_direction * knockback_strength * get_physics_process_delta_time()
	# Reset de knockback-timer
	knockback_time_elapsed = 0.0
	
	
func _physics_process(delta):
	
	# kanon explosie laten mee bewegen met de canon-gun
	player = GameData.playerBody
	var rotated_offset = offset.rotated(canon_gun.rotation)
	canon_fire.position = canon_gun.position + rotated_offset
	
	# kanon koppelen aan player en spel vrijgeven wanneer player dood gaat
	if !player:
		return
	if player:
		$canon_gun.look_at(player.global_position)
	
	# Kanon laten schieten of als het kanon niet dood is en geen schade krijgt
	if !dead and !taking_damage:
		if GameData.canon_can_shoot and cooldown_timer.is_stopped():
			print("Canon can shoot! ", GameData.canon_can_shoot)
			cooldown_timer.start()
	
		if not GameData.canon_can_shoot:
			cooldown_timer.stop()
	elif !dead and taking_damage:
		apply_knockback()
	elif dead:
		canon_destroy.play()
		await get_tree().create_timer(0.6).timeout
		handle_death()
	
	handle_knockback(delta)


func handle_death():
	queue_free()
		

func handle_knockback(delta):
	if knockback_time_elapsed < knockback_duration:
		# Verhoog de verstreken tijd
		knockback_time_elapsed += delta
		# Bereken de interpolatiefactor (hoeveel procent van de weg is afgelegd)
		var t = knockback_time_elapsed / knockback_duration
		# Beweeg het kanon terug naar de beginpositie
		global_position = global_position.lerp(canon_start_position, t)
	else:
		# Zorg ervoor dat we precies op de beginpositie eindigen
		global_position = canon_start_position
	
	
func _on_cooldown_timeout():
	print("cooldown canon-shoot")
	shoot()
	

func _on_canon_hitbox_body_entered(body):
	print("Canon hit by arrow")
