extends Node

#declaratie signaal naar the HUD
signal lives_changed(current_lives)
signal reset_countdown()

@export var level_start_pos_01 : Node2D

@onready var player_scene = preload("res://scenes/player.tscn")
@onready var die_sound = $die_sound
#@onready var first_player = $"../../player"
@onready var first_player = $"../../World/player"


var player_instance

var current_lives = 3
# Globale variabele om de player op te slaan
var current_player = null

var is_player_dying = false

func _ready():
	#print("first player", first_player)
	#print("health system lives: ", current_lives)
	#de verbinding met de nodes die een signaal verzenden
	$"../../World/Killzone".player_died.connect(player_die)
	%GameManager.countdown_player_died.connect(countdown_death)
	$"../../World/player".player_knight_died.connect(test)
	#var player = get_node("/root/Game/World/player")
	#player.player_died.connect(test)
	
	#var root = get_tree().root
	#var player = root.find_node("player", true, false)
	#$var player = get_tree().get_root().find_child("player")
	#if player:
		#player.player_died.connect(test)
	
	
	
	
# functie die hier wordt aangeroepen uit het slime script 
func connect_enemy_signals(enemy):
	enemy.player_hit.connect(player_die)


# player_die is de functie die wordt opgeroepen als het signaal wordt ontvangen
func player_die(body):
	#if player == null:
	if body != null:
		print("player_die: ", body)
		decrease_lives()
		# gevechts modus uit
		GameData.weapon_equip = false
		GameData.bow_equip = false
		#GameData.canon_can_shoot = false
		GameData.canon_right_can_shoot = false
		GameData.canon_left_can_shoot = false
		#print("health system : canon_can_shoot ", GameData.canon_can_shoot )
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
			# laat de sword_trigger terug komen
			%GameManager.level_manager.respawn_sword_trigger()
			# laat de bow_trigger terug komen
			%GameManager.level_manager.respawn_bow_trigger()
			# create new player
			var player_instance = player_scene.instantiate()
			
			# Verbind het signaal van de nieuwe speler aan de player_die functie
			#newPlayer.connect("player_knight_died", self, "player_die")
			
			# Stel de naam in
			#newPlayer.name = "player"
			#print("Health system Player instance name: ", newPlayer.name)
			
			# position player at start positiom
			player_instance.position = level_start_pos_01.position
			# add the new player to the game
			#get_parent().add_child(newPlayer)
			
			# Voeg het nieuwe object toe aan een specifieke parent
			var specific_parent = get_node("../../World")
			specific_parent.add_child(player_instance)
			
			# Verbind het signaal van player scene  "player_knight_died"opnieuw met de nieuwe instatie
			player_instance.player_knight_died.connect(test)
			
			# connecteer de boddy van player_instance opnieuw aan GameData zodat deze gevonden kan worden door de bats
			GameData.playerBody = player_instance
			#print("PLAYERBODY BIJ RESPAWN: ", player_instance.CharacterBody2D)
			#if player_instance.has_node("CharacterBody2D"):
				#print("PLAYERBODY BIJ RESPAWN: ", player_instance.get_node("CharacterBody2D"))
			#else:
				#print("CharacterBody2D node niet gevonden")
				
			#print("PLAYERBODY BIJ RESPAWN: ", player_instance)
			
			# belangrijk: laat de bat enemy weer aanvallen
			GameData.is_bat_chase = true
			# Update de huidige speler referentie
			current_player = player_instance
			emit_signal("reset_countdown")
			
			

		else:
			print("Game over")
			# zet de score op nul
			%GameManager.score = 0
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
	

func test(body):
	print("Health system signaal ontvangen van player die sterft door de bat")
	player_die(body)
	
	
	
	
	
	
	
	
