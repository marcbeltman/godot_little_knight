extends Area2D

@export var led_index: int = 0

@onready var gemstone_sprite = $Sprite2D
@onready var gemstone_sound = $AudioStreamPlayer2D
@onready var kill_points = $AnimationPlayer
@onready var http_request = $HTTPRequest



var kill_points_played = false # Vlag om bij te houden of de kill_points animatie is afgespeeld
var game_manager # var voor de game-manager om punten door te geven
var led_number = 5 # var led_index
#var url = "https://node-red.xyz/test"
var url = "https://node-red.xyz/gemChannel"

func _ready():
	# verbind met de game manager node
	game_manager = get_node_or_null("/root/Game/GameManager")
	
	# Verbind de callback voor het voltooien van de HTTP-aanroep
	http_request.request_completed.connect(_on_request_completed)
	
	# laat de gemstone sprite zien
	gemstone_sprite.visible = true
	
	# animatie gemstone sprite
	var tween = create_tween().set_loops()
	# Schaal klein
	tween.tween_property(gemstone_sprite, "scale", Vector2(1, 1), 0.4)
	# Schaal groot
	tween.tween_property(gemstone_sprite, "scale", Vector2(1.2, 1.2), 0.4)


func _on_body_entered(body):
	gemstone_sprite.visible = false
	if not kill_points_played:
		print("Gemstone hit by player")
		# check of er een gemstone is aangesloten
		if GameData.gemstone:
			print(" gemstone connection true: ", GameData.gemstone)
			send_request() # verstuur het http request

		kill_points.play("kill_points")
		kill_points_played = true
		if game_manager != null:
			game_manager.add_point(100)
		else:
			print("GEMSTONE: GameManager not found in the scene!")


# Functie om een POST-aanroep te doen
func send_request():
	# Zet de headers in voor een JSON-request
	var headers = ["Content-Type: application/json"]

	# Gegevens die we willen sturen (bijv. JSON-data)
	var data = {"playerAction": "collectGem", "command": led_index, "gameKey": GameData.gemstone["gameKey"]} 
	# coverteer naar een json string
	var json_data = JSON.stringify(data)  # Converteer naar JSON-string

	# Verstuur het POST-verzoek
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)

	# Controleer of er een fout was bij het versturen van het verzoek
	if error != OK:
		print("Error sending request: %s" % error)
	else:
		print("Request sent successfully!")


# Callback-functie wanneer het verzoek is voltooid
func _on_request_completed(result, response_code, headers, body):
	# Het antwoord van de server wordt als een string ontvangen, dus we moeten het parseren
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	print(json)
	# Controleer of het parseren van de JSON succesvol was
	#if json["status"] == "success":
		#print("response_code: ", response_code)
		
		# Verwerk het resultaat, bijvoorbeeld het tonen van een specifiek veld uit de JSON
		#label.text = json["received"]  # Pas dit aan afhankelijk van de JSON-structuur
		#print(json["received"])
	#else:
		#print("Failed to parse JSON response")
		#label.text = "Error parsing response"
