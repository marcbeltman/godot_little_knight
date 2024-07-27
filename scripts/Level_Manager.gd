extends Node

#declaratie signaal naar the Game manager
signal stop_countdown()


const FILE_BEGIN = "res://scenes/levels/level_"
@onready var game_manager = %GameManager
#@onready var game = $"../.."


# Called when the node enters the scene tree for the first time.
#func _ready():
	#$"../../World/Objects/Gates/Gate_A".gate_A_next_level.connect(next_level)
	#$"../../World/Objects/Gates/Gate_B".gate_next_level.connect(next_level)
	#$"../../World/Objects/Gates/Gate_C".gate_next_level.connect(next_level)
	#$"../../World/Objects/Gates/Gate_D".gate_next_level.connect(next_level)

func next_level(body):
	print("van levelmanager signaal van gate ontvangen: " , body)
	game_manager.countdown_stop()
	# zet de transitie in. fade-out fade-in overgang ander level is een globale functie
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	# bepaal het volgende level
	var current_scene_file = get_tree().current_scene.scene_file_path
	#print(current_scene_file)
	var next_level_number = current_scene_file.to_int() + 1
	#print(next_level_number)
	var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
	#print(next_level_path)
	get_tree().change_scene_to_file(next_level_path)
	
	#game.queue_free()
		# Verwijder de Game Manager node
	#if game_manager:
	#game_manager.countdown_stop()
	#game_manager.queue_free()
		#print("Game Manager verwijderd")
	#else:
		#print("Game Manager was niet beschikbaar voor verwijdering")

