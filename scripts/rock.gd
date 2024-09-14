extends Area2D

#declaratie signaal naar Health_System
signal player_died(body)

# Variabelen om de wiebeling te regelen
var amplitude = 10.0 # Hoeveel graden het object wiebelt
var frequency = 2.0 # Hoe snel het object wiebelt
var time = 0.0

# Variabelen voor de valconditie
#var is_falling = false
var fall_speed = 75.0 # De snelheid waarmee het object valt
var fall_acceleration = 200.0 # De valversnelling (voorheen 'gravity')

var has_played_sound = false

var health_system 

@onready var audio_stream_player = $AudioStreamPlayer2D


func _ready():
	GameData.rock_is_falling = false
	health_system = get_node_or_null("/root/Game/GameManager/Health_System")

func _process(delta):
	if GameData.rock_is_falling:
		if not has_played_sound:
			audio_stream_player.play()
			has_played_sound = true
		# Val naar beneden door de Y-positie aan te passen
		position.y += fall_speed * delta
		# Versnel het object door de valversnelling toe te passen
		fall_speed += fall_acceleration * delta
	else:
		# Wiebelen als het object nog niet valt
		time += delta
		var angle = sin(time * frequency) * deg_to_rad(amplitude)
		rotation = angle


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	

func _on_body_entered(body):
	print("KLOTEKUTZOOI")
	health_system.player_die(body)
