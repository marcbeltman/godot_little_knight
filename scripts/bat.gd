extends CharacterBody2D

class_name BatEnemy

@onready var kill_points = $AnimationPlayer

@onready var audio_player = $AudioStreamPlayer2D
# Minimale en maximale tijd tussen afspelingen (in seconden)
var min_delay: float = 1.0
var max_delay: float = 1.5

const speed = 60
var dir: Vector2
var is_bat_chase: bool
var player: CharacterBody2D

var health = 50
var health_max = 50
var health_min = 0
var dead = false
var taking_damage = false
var is_roaming: bool
var damage_to_deal = 20

# Vlag om bij te houden of de kill_points animatie is afgespeeld
var kill_points_played = false

func _ready():
	# belangrijk: start de aanval van de bat enemy
	GameData.is_bat_chase = true
	#is_bat_chase = true
	#_play_random_sound()
	

func _process(delta):
	# belangrijk: kijk constant of de bat enemy moet aanvallen of niet
	is_bat_chase = GameData.is_bat_chase
	GameData.batDamageAmount = damage_to_deal
	GameData.batDamageZone = $BatDealDamageArea
	
	# verwijderen van de gestorven bat
	if is_on_floor() and dead:
		#play kill_points animatie
		if not kill_points_played:
			kill_points.play("kill_points")
			kill_points_played = true
			%GameManager.add_point(30)
		await get_tree().create_timer(2.0).timeout
		self.queue_free()
		
	move(delta)
	handle_animation()


func move(delta):
	player = GameData.playerBody
	
	# Controleer of de player bestaat
	if !player:
		return  # Verlaat de functie als de player niet bestaat

	if !dead:
		is_roaming = true
		if !taking_damage and is_bat_chase:
			# Controleer of de player nog geldig is voordat je de richting berekent
			if player:
				velocity = position.direction_to(player.position) * speed
				dir.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * -50
			velocity = knockback_dir
		else:
			velocity += dir * speed * delta
	elif dead:
		velocity.y += 10 * delta
		velocity.x = 0
	
	move_and_slide()

	
	
func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 0.8])
	if !is_bat_chase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
		print(dir)
	
	
func choose(array):
	array.shuffle()
	return array.front()
	

func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	if !dead and !taking_damage:
		animated_sprite.play("fly")
		if dir.x == -1:
			animated_sprite.flip_h = true
		elif dir.x == 1:
			animated_sprite.flip_h = false
	elif !dead and taking_damage:
		animated_sprite.play("hurt")
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead and is_roaming:
		is_roaming = false
		animated_sprite.play("death")
		#set_collision_layer_value(1, true)
		#set_collision_layer_value(2, true)



func _play_random_sound() -> void:
	while true:
		# Speel het geluid af
		audio_player.play()

		# Wacht totdat het geluid klaar is met afspelen (optioneel)
		await audio_player.finished

		# Bepaal een willekeurige tijd voor de volgende afspeling
		var delay_time = randf_range(min_delay, max_delay)

		# Wacht voor de willekeurige tijd
		await get_tree().create_timer(delay_time).timeout



#func _on_bat_hit_box_area_entered(area):
	#if area == GameData.playerDamageZone:
		#var damage = GameData.playerDamageAmount
		#take_damage(damage)
		#print("bat hit by player")






		
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
	print(str(self), "current health is ", health)
		

func _on_bat_hit_box_area_entered(area):
	if area == GameData.playerDamageZone:
		var damage = GameData.playerDamageAmount
		take_damage(damage)
		audio_player.play()
		print("bat hit by player")
