extends Node


@export var level_start_pos_01 : Node2D

@onready var player_scene = preload("res://scenes/player.tscn")
@onready var die_sound = $die_sound

#declaratie signaal naar the HUD
signal lives_changed(current_lives)


var player = null
var current_lives = 3

func _ready():
	print("health system lives: ", current_lives)
	#de verbinding met de nodes die een signaal verzenden
	$"../../World/Killzone".player_died.connect(player_die)

	$"../../World/Enemies/slime".player_hit.connect(player_die)

	$"../../World/Objects/Gates/Gate_A".gate_player_died.connect(player_die)
	$"../../World/Objects/Gates/Gate_B".gate_player_died.connect(player_die)


#func aap():
	#print("van healthsystem : signaal van gate ontvangen")


# player_die is de functie die wordt opgeroepen als het signaal wordt ontvangen
func player_die(body):
	if player == null:
		decrease_lives()
		print("health system lives: ", current_lives)
		#body.get_node("CollisionShape2D").queue_free()
		die_sound.play()
		
		# stop collision
		#body.collision_layer = 0
		# stop controls player 
		#body.set_physics_process(false)
		# player not visible
		#body.visible = false
		
		# remove CollisionShape2D from player
		body.get_node("CollisionShape2D").queue_free()
		# wait one seconde to respawn
		await get_tree().create_timer(1).timeout
		# destroy player
		body.queue_free()
		respawn_player(body)


# respawn_player is de functie die de player opniew laat komen op gewenste level_start_pos of game over
func respawn_player(body):
		if current_lives  >= 1:
			# create new player
			var newPlayer = player_scene.instantiate()
			# position player at start positiom
			newPlayer.position = level_start_pos_01.position
			# add the new player to the game
			add_child(newPlayer)
		else:
			print("Game over")
			#TransitionScreen.transition()
			#await TransitionScreen.on_transition_finished
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
func decrease_lives():
	current_lives -= 1
	emit_signal("lives_changed", current_lives)




	
	
	
	
	
	
	
	
	
	
	
