extends CharacterBody2D

@export var SPEED = 100

var dir : float
var spawnPos : Vector2
var spawnRot : float
var zdex : int

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot 
	z_index = zdex
		

func _physics_process(delta):
	rotation_degrees += 500 * delta
	velocity = Vector2(SPEED,0).rotated(dir)
	move_and_slide()


func _on_life_timeout():
	queue_free()
