extends StaticBody2D


@export var player_path : NodePath
var player : Node2D

@export var knockback_strength := 200.0  # De sterkte van de knockback
@export var knockback_duration := 1.0  # Hoe lang de knockback moet duren


@onready var Game = get_tree().get_root().get_node("Game")
@onready var projectile = load("res://scenes/canon_projectile.tscn")
@onready var cooldown_timer = $Cooldown
@onready var canon_sound = $CanonSound

var canon_start_position: Vector2
var knockback_time_elapsed: float = 0.0  # Tijd die verstreken is sinds de knockback begon


# Called when the node enters the scene tree for the first time.
func _ready():
	# Sla de beginpositie op bij het laden van de scène
	canon_start_position = global_position
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_timeout"))
	cooldown_timer.start()  # Start de timer als het niet automatisch gebeurt
	#shoot()
	z_index = 5
	
	if player_path:
		player = get_node(player_path)
	else:
		print("CANON: Player path is not set!")
	
	
	


func shoot(): 
	print("canon-shoot")
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
	handle_knockback(delta)
	#if player:
	if is_instance_valid(player):
		$canon_gun.look_at(player.global_position)

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
