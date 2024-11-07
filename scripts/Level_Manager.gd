extends Node

#declaratie signaal naar the Game manager
signal stop_countdown()


const FILE_BEGIN = "res://scenes/levels/level_"
@onready var game_manager = %GameManager

# preload van de sword_trigger
@onready var sword_trigger_new = preload("res://scenes/sword_trigger.tscn")
# positie sword_trigger
@onready var sword_trigger_old = $"../../sword_trigger"

# preload van de bow_trigger
@onready var bow_trigger_new = preload("res://scenes/bow_trigger.tscn")
# positie bow_trigger
@onready var bow_trigger_one = $"../../World/Objects/Triggers/bow_trigger_1"
@onready var bow_trigger_two = $"../../World/Objects/Triggers/bow_trigger_2"



# Globale variabele om de positie van de sword_trigger in op te slaan
var sword_trigger_position = null
var bow_trigger_one_position = null
var bow_trigger_two_position = null

func _ready():
	# get position from sword trigger
	get_position_sword_trigger()
	get_position_bow_trigger_one()
	get_position_bow_trigger_two()

func next_level(body):
	print("van levelmanager signaal van gate ontvangen: " , body)
	game_manager.countdown_stop()
	var achieved_score = %GameManager.score
	GameData.score = achieved_score
	# zet de transitie in. fade-out fade-in overgang ander level is een globale functie
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	# vernietig de player
	#body.queue_free()
	
	# bepaal het volgende level
	var current_scene_file = get_tree().current_scene.scene_file_path
	print(current_scene_file)
	var next_level_number = current_scene_file.to_int() + 1
	print(next_level_number)
	
	## SCORE EN PLAYERNAME NAAR QUIVER LEADERBOARD
	if next_level_number == 6:
		await Leaderboards.post_guest_score("scipio-leaderboard-BeYE", GameData.score, GameData.player_name)
	
	var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
	print(next_level_path)
	get_tree().change_scene_to_file(next_level_path)


func get_position_sword_trigger():
	#controleer of sword_trigger_old bestaat
	if sword_trigger_old: 
		var position = sword_trigger_old.global_position
		# controleer of 
		if position:
			sword_trigger_position = position
		else:
			print("sword_trigger has no valit position.")
	else: 
		print("sword_trigger does not existe in this level.")


func get_position_bow_trigger_one():
	#controleer of sword_trigger_old bestaat
	if bow_trigger_one: 
		var position = bow_trigger_one.global_position
		# controleer of 
		if position:
			bow_trigger_one_position = position
		else:
			print("bow_trigger has no valit position.")
	else: 
		print("bow_trigger does not existe in this level.")

func get_position_bow_trigger_two():
	#controleer of sword_trigger_old bestaat
	if bow_trigger_two: 
		var position = bow_trigger_two.global_position
		# controleer of 
		if position:
			bow_trigger_two_position = position
		else:
			print("bow_trigger has no valit position.")
	else: 
		print("bow_trigger does not existe in this level.")





func respawn_sword_trigger():
	print("Levelmanager respawn_sword_trigger: signaal van healthsystem ontvangen ")
	if sword_trigger_position:
		#print("sword_trigger_postion werd gevonden", sword_trigger_position )
		var new_trigger = sword_trigger_new.instantiate()
		#print("Nieuw geïnstantieerd object:",new_trigger)
		new_trigger.position = sword_trigger_position
		#print("Positie van nieuw object:", new_trigger.position)
		add_child(new_trigger)
		#print("Nieuwe sword_trigger toegevoegd aan de scene")
	else:
		print("sword_trigger could not be found or does not existe in this level.")
		
		
func respawn_bow_trigger_one():
	print("Levelmanager respawn_bow_trigger: signaal van healthsystem ontvangen ")
	if bow_trigger_one_position:
		#print("sword_trigger_postion werd gevonden", sword_trigger_position )
		var new_trigger = bow_trigger_new.instantiate()
		#print("Nieuw geïnstantieerd object:",new_trigger)
		new_trigger.position = bow_trigger_one_position
		#print("Positie van nieuw object:", new_trigger.position)
		add_child(new_trigger)
		#print("Nieuwe sword_trigger toegevoegd aan de scene")
	else:
		print("bow_trigger could not be found or does not existe in this level.")
	
func respawn_bow_trigger_two():
	print("Levelmanager respawn_bow_trigger: signaal van healthsystem ontvangen ")
	if bow_trigger_two_position:
		#print("sword_trigger_postion werd gevonden", sword_trigger_position )
		var new_trigger = bow_trigger_new.instantiate()
		#print("Nieuw geïnstantieerd object:",new_trigger)
		new_trigger.position = bow_trigger_two_position
		#print("Positie van nieuw object:", new_trigger.position)
		add_child(new_trigger)
		#print("Nieuwe sword_trigger toegevoegd aan de scene")
	else:
		print("bow_trigger could not be found or does not existe in this level.")
	
	
	
