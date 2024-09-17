extends Node2D

#declaratie signaal naar Health_System
signal player_hit(body)

const SPEED = 80


var direction = 1

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# maak verbindinding met de health system
	var health_system = get_node("/root/Game/GameManager/Health_System")
	# in health system maak verbinding met de fuctie connect_enemy_signals
	print("health_system: ", health_system)
	health_system.connect_enemy_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
		
	position.x += direction * SPEED * delta






func _on_area_2d_body_entered(body):
	print("enemy: player hit")
	player_hit_enemy(body)
	
	
func player_hit_enemy(body):
	# verzenden signaal naar Health_System
	player_hit.emit(body)
