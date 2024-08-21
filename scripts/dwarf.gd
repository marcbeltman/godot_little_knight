extends CharacterBody2D

class_name DwarfEnemy


@onready var audio_player = $AudioStreamPlayer2D

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

var player: CharacterBody2D
var player_in_area = false

func _ready():
	# belangrijk: start de aanval van de bat enemy
	GameData.is_dwarf_chase = true


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
	if !dead:
		if !is_dwarf_chase:
			velocity += dir * speed * delta 
		elif is_dwarf_chase and !taking_damage:
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
	elif dead and is_roaming:
		is_roaming = false
		anim_sprite.play("death")
		await get_tree().create_timer(1.0).timeout
		handle_death()
	elif !dead and is_dealing_damage:
		anim_sprite.play("attack")
		

func handle_death():
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
	var damage = GameData.playerDamageAmount
	if area == GameData.playerDamageZone:
		take_damage(damage)
		
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
	print(str(self), "current health is ", health)



func _on_dwarf_deal_damage_area_area_entered(area):
	if area == GameData.playerHitBox:
		is_dealing_damage = true
		audio_player.play()
		await get_tree().create_timer(1.0).timeout
		is_dealing_damage = false
