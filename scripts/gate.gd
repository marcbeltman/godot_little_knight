extends Area2D

# Declaratie van signalen
signal gate_player_died(body)
signal gate_next_level(body)

# variabelen extern inspector
@export var gate_letter: String
@export var right_gate: bool

@onready var gate_letter_label = $gate_letter_label
@onready var open_gate_sound = $open_gate_sound
@onready var wrong_gate_sound = $wrong_gate_sound
@onready var right_gate_sound = $right_gate_sound
@onready var animated_sprite = $AnimatedSprite2D

# var voor algene beschikbaarheid in het script
var body_to_process = null
#  vlag om 1x een animatie af te spelen
var animation_played = false

func _ready():
	# check externe variabele of gate letter is toegekend 
	if gate_letter == "":
		print("Gate: Gate letter not asigned")
	else:
		gate_letter_label.text = gate_letter

	# Verbind de signalen met de juiste functies uit Heath_system en Level_Manager
	var health_system = get_node("../../../../GameManager/Heath_System")
	# chek aanwezigheid
	if health_system:
		# Haal de nodige functie op uit health_system
		connect("gate_player_died", Callable(health_system, "player_die"))
	else:
		print("Gate: Health_System not found")

	var level_manager = get_node("../../../../GameManager/Level_Manager")
	if level_manager:
		connect("gate_next_level", Callable(level_manager, "next_level"))
	else:
		print("Gate: Level_Manager not found")

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
	# als de bool right_gate in de inspector is aangevinkt
	if right_gate:
		# ga verder met de code, pas als right_gate_sound klaar is met spelen
		right_gate_sound.finished.connect(Callable(self, "_on_audio_right_gate_sound_finished"))
		right_gate_sound.play()
	# als de bool right_gate NIET in de inspector is aangevinkt
	else:
		wrong_gate_sound.play()
		# als de body van player bestaat
		if body_to_process:
			# zet de controls van de player aan
			body_to_process.set_physics_process(true)
			# verstuur het signaal met de player (body) en roep de fuctie "player_die" van de health sytem op
			die(body_to_process)
			# maak de var body_to_process weer leeg
			body_to_process = null

func _on_audio_right_gate_sound_finished():
	# als de body van player bestaat
	if body_to_process:
		# verstuur het signaal met de player (body) en roep de fuctie "next_level" van de level manager op
		next_level(body_to_process)
		body_to_process = null

# functies om de signalen te verzenden met de body van de player
func die(body):
	emit_signal("gate_player_died", body)

func next_level(body):
	emit_signal("gate_next_level", body)
