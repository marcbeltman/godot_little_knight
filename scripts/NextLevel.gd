extends Area2D

@onready var audio_player = $next_level_sound

const FILE_BEGIN = "res://scenes/levels/level_"

func _on_body_entered(body):
	print("next_level geraakt door player")
	# schakelt de beweging van de player uit
	body.set_physics_process(false)
	# Connect het "finished" signaal van de audio_player met de "_on_audio_player_finished" functie.
	audio_player.finished.connect(self._on_audio_player_finished)
	audio_player.play()
	
# Deze functie wordt aangeroepen wanneer het "finished" signaal wordt afgegeven.
func _on_audio_player_finished():
	print("Het geluid is afgelopen!")
	# fade-out fade-in overgang ander level is een globale functie
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	# Voer hier de code uit die je wilt uitvoeren nadat het geluid is afgespeeld.
	next_level()

# De functie die wordt aangeroepen vanuit "_on_audio_player_finished" om naar volgend level te gaan.
func next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	print(current_scene_file)
	var next_level_number = current_scene_file.to_int() + 1
	print(next_level_number)
	var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
	print(next_level_path)
	get_tree().change_scene_to_file(next_level_path)

# wordt niet gebruikt
func frameFreeze(timeScale, duration):
	Engine.time_scale = timeScale
	await(get_tree().create_timer(duration * timeScale).timeout)
	Engine.time_scale = 1


