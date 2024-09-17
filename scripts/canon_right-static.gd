extends StaticBody2D

class_name Canon

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


func _ready():
	# Sla de beginpositie op bij het laden van de scène
	canon_start_position = global_position
	cooldown_timer.connect("timeout", Callable(self, "_on_cooldown_timeout"))
	z_index = 5
	#collision_shape_2d.set_physics_process(false)
	GameData.canon_right_static_can_shoot = true

	
func shoot(): 
	print("canon-shoot")
	canon_fire.play()
	canon_sound.play()
	var instance = projectile.instantiate()
	instance.dir = $canon_gun/Marker_respawn.global_rotation
	#instance.dir = $canon_gun/Marker_respawn.global_rotation + PI
	instance.spawnPos = $canon_gun/Marker_respawn.global_position
	instance.spawnRot = rotation
	Game.add_child.call_deferred(instance)
	#apply_knockback()


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
	#if !player:
		#return
	#if player:
		#$canon_gun.look_at(player.global_position)
	
	# Kanon laten schieten of als het kanon niet dood is en geen schade krijgt
	if !dead and !taking_damage:
		if GameData.canon_right_static_can_shoot and cooldown_timer.is_stopped():
			#print("Canon can shoot! ", GameData.canon_can_shoot)
			cooldown_timer.start()
	
		if not GameData.canon_right_static_can_shoot:
			cooldown_timer.stop()
	elif !dead and taking_damage:
		print("poep")
		#apply_knockback()
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
	

#func _on_canon_hitbox_body_entered(body):
	#check_hitbox(body)
	#print("FUCKSEL:" , body)
	#if body is Arrow:
		#print("ARROW HIT CANON")
		#apply_knockback()
		#var damage = GameData.arrowDamageAmount
		#take_damage(damage)


func _on_canon_hitbox_area_entered(area):
	print("ARROW HIT CANON")
	area.queue_free()
	var damage = GameData.arrowDamageAmount
	take_damage(damage)



func check_hitbox(body):
	var hitbox_areas = $canon_hitbox.get_overlapping_areas()
	#var damage: int
	if hitbox_areas:
		var hitbox = hitbox_areas.front()
		if hitbox.get_parent() is Player:
			#damage = GameData.batDamageAmount
			print("PLAYER HIT THE CANON")
			%GameManager.get_node("Health_System").player_die(body)
		#elif hitbox.get_parent() is Arrow:
			#print("ARROW HIT CANON")
			#body.queue_free()
			#var damage = GameData.arrowDamageAmount
			#take_damage(damage)





			
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
	print(str(self), "current health is ", health)


