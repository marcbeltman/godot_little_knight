extends CharacterBody2D

class_name DwarfEnemy

@onready var kill_points = $AnimationPlayer

@onready var attack_sound = $AttackSound
@onready var hurt_sound = $HurtSound
@onready var death_sound = $DeathSound

const speed = 80
var is_dwarf_chase: bool = true

var health = 80
var health_max = 80
var health_min = 0

var dead: bool = false
var taking_damage: bool = false
var damage_to_deal = 20
var is_dealing_damage: bool = false

var dir: Vector2
const gravity = 900
var knockback_force = -50
var is_roaming: bool = true
var death_animation_playing: bool = false

var player: CharacterBody2D
var player_in_area = false

var game_manager


func _ready():
	# belangrijk: start de aanval van de bat enemy
	GameData.is_dwarf_chase = true
	game_manager = get_node_or_null("/root/Game/GameManager")

func _process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		velocity.x = 0

	GameData.dwarfDamageAmount = damage_to_deal
	GameData.dwarfDamageZone = $DwarfDealDamageArea
	player = GameData.playerBody
	
	move(delta)
	handle_animation()
	move_and_slide()


func move(delta):

	# Controleer of de player bestaat
	if !player:
		return  # Verlaat de functie als de player niet bestaat

	if !dead:
		if !is_dwarf_chase:
			velocity += dir * speed * delta 
		elif is_dwarf_chase and !taking_damage:
			# Controleer of de player nog geldig is voordat je de richting berekent
			if player:
				var dir_to_player = position.direction_to(player.position) * speed
				velocity.x = dir_to_player.x
				dir.x = abs(velocity.x) / velocity.x
		elif taking_damage:
			print("dwarf krijgt een klap")
			var knockback_dir = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		velocity.x = 0

#func move(delta):
	#if !dead:
		#if !is_dwarf_chase:
			#velocity += dir * speed * delta 
		#elif is_dwarf_chase and !taking_damage:
			#var dir_to_player = position.direction_to(player.position) * speed
			#velocity.x = dir_to_player.x
			#dir.x = abs(velocity.x) / velocity.x
		#elif taking_damage:
			#print("dwarf krijgt een klap")
			#var knockback_dir = position.direction_to(player.position) * knockback_force
			#velocity.x = knockback_dir.x
		#is_roaming = true
	#elif dead:
		#velocity.x = 0
		
		
func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("run")
		if dir.x == -1:
			anim_sprite.flip_h = true
		elif dir.x == 1:
			anim_sprite.flip_h = false
	elif !dead and taking_damage and !is_dealing_damage:
		anim_sprite.play("damage")
		await get_tree().create_timer(0.8).timeout
		taking_damage = false
	elif dead and is_roaming and !death_animation_playing:
		is_roaming = false
		death_animation_playing = true  # Markeer dat de doodsanimatie is gestart
		anim_sprite.play("death")
		await get_tree().create_timer(0.8).timeout
		handle_death()
	elif !dead and is_dealing_damage:
		anim_sprite.play("attack")
		

func handle_death():
	kill_points.play("kill_points")
	if game_manager != null:
		game_manager.add_point(30)
	else:
		print("DWARF-ENEMY: GameManager not found in the scene!")
	death_sound.play()
	await get_tree().create_timer(1.5).timeout
	self.queue_free()

			
func _on_timer_timeout():
	$DirectionTimer.wait_time = choose([1.5, 2.0, 2.5])
	if !is_dwarf_chase:
		dir = choose([Vector2.RIGHT, Vector2.LEFT])
		velocity.x = 0


func choose(array):
	array.shuffle()
	return array.front()
	


func _on_dwarf_hitbox_area_entered(area):
	
	if area == GameData.playerDamageZone:
		var damage = GameData.playerDamageAmount
		take_damage(damage)
	elif area == GameData.arrowDamageZone:
		var damage = GameData.arrowDamageAmount
		take_damage(damage)

		
		
		
		
		
		
func take_damage(damage):
	#var anim_sprite = $AnimatedSprite2D
	hurt_sound.play()
	health -= damage
	taking_damage = true
	if health <= 0 and !death_animation_playing:
		health = 0
		dead = true
		#death_animation_playing = true
		#anim_sprite.play("death")
	print(str(self), "current health is ", health)



func _on_dwarf_deal_damage_area_area_entered(area):
	if area == GameData.playerHitBox:
		is_dealing_damage = true
		attack_sound.play()
		await get_tree().create_timer(1.0).timeout
		is_dealing_damage = false
	
