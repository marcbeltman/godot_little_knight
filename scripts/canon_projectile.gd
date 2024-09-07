extends CharacterBody2D

class_name CanonProjectile

@export var SPEED = 100
@onready var explosion = $AnimatedSprite2D

#var dir : float
#var dir : float = 3 * PI / 2  # Standaard richting naar rechts (270 graden)
var dir : float 
var spawnPos : Vector2
var spawnRot : float
var zdex : int
var damage_to_deal = 25


func _ready():
	explosion.animation_finished.connect(_on_animation_finished)
	global_position = spawnPos
	global_rotation = spawnRot 
	#z_index = zdex
	z_index = 4

func _physics_process(delta):
	GameData.canonDamageAmount = damage_to_deal
	rotation_degrees += 500 * delta
	velocity = Vector2(SPEED,0).rotated(dir)
	move_and_slide()
	

func _on_life_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	print("PROJECTILE: player hit!!!", body)
	if body is CharacterBody2D:
		explosion.play("explosion")
	else:
		queue_free()	
	
	
func _on_animation_finished():
	queue_free()	
	
	

