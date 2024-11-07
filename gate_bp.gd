extends Area2D

@onready var open_gate_sound = $open_gate_sound
@onready var right_gate_sound = $right_gate_sound
@onready var animated_sprite = $AnimatedSprite2D

# var voor algene beschikbaarheid in het script
var body_to_process = null
#  vlag om 1x een animatie af te spelen
var animation_played = false


func _on_body_entered(body):
	print("Gate: hit by player")
	# stop controls player 
	body.set_physics_process(false)
	# ken de player toe aan een de externe var voor beshikbaarheid
	body_to_process = body
	# ga verder met de code,  pas als open_gate_sound klaar is met spelen
	open_gate_sound.finished.connect(Callable(self, "_on_audio_open_gate_sound_finished"))
	# check of de animatie al een keer is afgespeeld
	if not animation_played:
		open_gate_sound.play()
		animated_sprite.play("open")
		# animatie is afgespeeld var vlag wordt op true gezet
		animation_played = true

# open_gate_sound is klaar met afspelen
func _on_audio_open_gate_sound_finished():

		# ga verder met de code, pas als right_gate_sound klaar is met spelen
		right_gate_sound.finished.connect(Callable(self, "_on_audio_right_gate_sound_finished"))
		right_gate_sound.play()


func _on_audio_right_gate_sound_finished():
	# als de body van player bestaat
	if body_to_process:
		# verstuur het signaal met de player (body) en roep de fuctie "next_level" van de level manager op
		next_level(body_to_process)
		body_to_process = null


func next_level(body):
	print("BACK TO MENU")
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/toy_menu_test.tscn")
	
