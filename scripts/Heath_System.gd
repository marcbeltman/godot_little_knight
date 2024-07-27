extends Node

#declaratie signaal naar the HUD
signal lives_changed(current_lives)
signal reset_countdown()

@export var level_start_pos_01 : Node2D

@onready var player_scene = preload("res://scenes/player.tscn")
@onready var die_sound = $die_sound
@onready var first_player = $"../../player"


var current_lives = 3
# Globale variabele om de player op te slaan
var current_player = null

var is_player_dying = false

func _ready():
	#print("first player", first_player)
	#print("health system lives: ", current_lives)
	#de verbinding met de nodes die een signaal verzenden
	$"../../World/Killzone".player_died.connect(player_die)
	$"../../World/Enemies/slime".player_hit.connect(player_die)
	%GameManager.countdown_player_died.connect(countdown_death)


	
# player_die is de functie die wordt opgeroepen als het signaal wordt ontvangen
func player_die(body):
	#if player == null:
	if body != null:
		print("player_die: ", body)
		decrease_lives()
		print("health system lives: ", current_lives)
		#body.get_node("CollisionShape2D").queue_free()
		die_sound.play()
		# remove CollisionShape2D from player
		body.get_node("CollisionShape2D").queue_free()
		# wait one seconde to respawn
		await get_tree().create_timer(1).timeout
		# destroy player
		body.queue_free()
		respawn_player(body)
	else:
		print("Health sysytem: Player body is null.")


# respawn_player is de functie die de player opniew laat komen op gewenste level_start_pos of game over
func respawn_player(body):
		if current_lives  >= 1:
			# create new player
			var newPlayer = player_scene.instantiate()
			# position player at start positiom
			newPlayer.position = level_start_pos_01.position
			# add the new player to the game
			get_parent().add_child(newPlayer)
			# Update de huidige speler referentie
			current_player = newPlayer
			emit_signal("reset_countdown")

		else:
			print("Game over")
			TransitionScreen.transition()
			await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
			
			
func decrease_lives():
	current_lives -= 1
	emit_signal("lives_changed", current_lives)


func countdown_death():
	print("Health manager: countdown death")
	#if is_player_dying:
		#print("Player is already dying, ignoring duplicate call.")
		#return
	
	#is_player_dying = true
	
	
	# de eerste keer wanneer de player nog niet is dood gegaan is current_player null
	if current_player == null:
		print("Health system: current player is null.")
		#zoek dan de player
		#var player_node = player_scene.instantiate()
		#get_parent().add_child(player_node)
		#print("gamemanager: player_node: ", player_node )
		# en laat hem dood gaan
		player_die(first_player)
	#als current player niet meer null is door respawn
	elif current_player != null:
		player_die(current_player)
	else:
		print("Health sysytem: Player node not found.")
	
	
	
	
	
	
	
	
	
	
	
