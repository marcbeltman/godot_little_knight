extends Area2D

#declaratie signaal naar Health_System
signal gate_player_died(body)

@export var gate_letter: String


@onready var gate_letter_label = $gate_letter_label
@onready var open_gate_sound = $open_gate_sound
@onready var wrong_gate_sound = $wrong_gate_sound
@onready var animated_sprite = $AnimatedSprite2D

var body_to_process = null
# vlag voor eenmalige animatie en sound
var animation_played = false

func _ready():
	if gate_letter == "":
		print("De letter voor de gate is niet ingevuld")
	else:
		gate_letter_label.text = gate_letter


func _on_body_entered(body):
	print("hit by player")
	body_to_process = body
	# schakelt de beweging van de player uit
	body_to_process.set_physics_process(false)
	# Verbinden van het finished-signaal van de eerste AudioStreamPlayer aan een functie
	open_gate_sound.finished.connect(_on_audio_open_gate_sound_finished)
	# code om animatie en geluid 1 keer te spelen
	if not animation_played:
		# Start het afspelen van het eerste geluid gate open
		open_gate_sound.play()
		# Start de animatie
		animated_sprite.play("open")
		# zet de vlag op true
		animation_played = true

# Callback functie wanneer het eerste geluid klaar is met afspelen
func _on_audio_open_gate_sound_finished():
	#print("Eerste geluid is klaar met afspelen")
		# Start het afspelen van het geluid wrong_gate_sound 
		wrong_gate_sound.play()
		# als de body van de player is gedetecteerd
		if body_to_process:
			print("Processing body:", body_to_process)
			# functie om signaal naar health-system te sturen
			die(body_to_process)
			# Reset de variabele na verwerking
			body_to_process = null 

func die(body):
	# schakelt de beweging van de player aan zodat deze kan vallen
	body_to_process.set_physics_process(true)
	#verzenden signaal naar Health_System
	gate_player_died.emit(body)
	
	
