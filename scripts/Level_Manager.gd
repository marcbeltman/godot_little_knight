extends Node

#declaratie signaal naar the Game manager
signal stop_countdown()


const FILE_BEGIN = "res://scenes/levels/level_"
@onready var game_manager = %GameManager

# preload van de sword_trigger
@onready var sword_trigger_new = preload("res://scenes/sword_trigger.tscn")
# positie sword_trigger
@onready var sword_trigger_old = $"../../sword_trigger"

# Globale variabele om de positie van de sword_trigger in op te slaan
var sword_trigger_position = null


func _ready():
	# get position from sword trigger
	get_position_sword_trigger()
	

func next_level(body):
	print("van levelmanager signaal van gate ontvangen: " , body)
	game_manager.countdown_stop()
	var achieved_score = %GameManager.score
	GameData.score = achieved_score
	# zet de transitie in. fade-out fade-in overgang ander level is een globale functie
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	# bepaal het volgende level
	var current_scene_file = get_tree().current_scene.scene_file_path
	print(current_scene_file)
	var next_level_number = current_scene_file.to_int() + 1
	print(next_level_number)
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
		
	
	
	
