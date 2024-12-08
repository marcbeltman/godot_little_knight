extends Control


@onready var http_request_post = $HTTPRequest_POST
@onready var http_request_get = $HTTPRequest_GET
@onready var line_edit = $MarginContainer/VBoxContainer2/LineEdit
@onready var message = $MarginContainer/Label_message
@onready var connect_btn = $MarginContainer/VBoxContainer2/VBoxContainer3/Post_Button

var game_key : int = 0
var gemstone_SN : String = ""

var gemstone_obj = {}


var led_number = 1 # var led_index
var url_post = "https://node-red.xyz/test"
var url_get = "https://node-red.xyz/get_gemstone"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Verbind de callback voor het voltooien van de HTTP-aanroep
	http_request_post.request_completed.connect(_on_post_request_completed)
	http_request_get.request_completed.connect(_on_get_request_completed)

	line_edit.connect("text_changed", Callable(self, "_on_text_changed"))


	if GameData.gemstone:
		connect_btn.visible = false
		message.add_theme_color_override("font_color", Color(0, 0.5, 0))  # Groen
		message.text = "GEMSTONE CONNECTED"
	else:
		connect_btn.visible = true
	
	
	#search_btn.visible = true

# Functie om een POST-aanroep te doen
func send_post_request(data):
	# Zet de headers in voor een JSON-request
	var headers = ["Content-Type: application/json"]

	# Gegevens die we willen sturen (bijv. JSON-data)
	# coverteer naar een json string
	var json_data = JSON.stringify(data)  # Converteer naar JSON-string

	# Verstuur het POST-verzoek
	var error = http_request_post.request(url_post, headers, HTTPClient.METHOD_POST, json_data)
	# Controleer of er een fout was bij het versturen van het verzoek
	if error != OK:
		print("Error sending request: %s" % error)
	else:
		print("Request sent successfully!")


# Callback-functie wanneer het verzoek is voltooid
func _on_post_request_completed(result, response_code, headers, body):
	# Het antwoord van de server wordt als een string ontvangen, dus we moeten het parseren
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	if json.has("serialnr"):
		message.add_theme_color_override("font_color", Color(0, 0.5, 0))  # Groen
		message.text = "Gemstone: %s was found, gemstone connected" % str(json["serialnr"])
		#print("game_key: ", game_key)
		#print("gemstone_SN: ", gemstone_SN)
		gemstone_obj = create_gemstone_object(game_key, gemstone_SN)
		print(gemstone_obj)
		# gemstone object wordt naar GameData gestuurd
		GameData.gemstone = gemstone_obj
		connect_btn.visible = false
	else:
		message.text = "No gemstone with that serialnr was found"

	
	
	
	
	


# Functie om een GET-aanroep te doen
func send_get_request():
	# Zet de headers in voor een GET-request
	var headers = ["Content-Type: application/json"]

	# Verstuur het GET-verzoek
	var error = http_request_get.request(url_get, headers, HTTPClient.METHOD_GET)

	# Controleer of er een fout was bij het versturen van het verzoek
	if error != OK:
		print("Error sending GET request: %s" % error)
	else:
		print("GET request sent successfully!")

# Callback voor GET-verzoek
func _on_get_request_completed(result, response_code, headers, body):
	if response_code == 200:  # Controleer of de respons succesvol was
		# Parse de body als JSON
		var json = JSON.parse_string(body.get_string_from_utf8())
		
		print(json)
		






# callback functie om de message text te laten verdwijnen bij nieuwe input
func _on_text_changed(new_text: String):
	if new_text:
		message.text = ""


# helper functie om een timestamp te genereren voor de game-code
func get_unix_timestamp():
	var unix_time = Time.get_unix_time_from_system()
	return int(unix_time)


# helper functie om invoer LineEdit te controleren
func is_lineedit_not_empty(line_edit: LineEdit) -> bool:
	return line_edit.text.strip_edges() != ""

# Functie om de tekst uit de LineEdit op te halen
func read_input():
	# Controleer of de LineEdit niet leeg is
	if is_lineedit_not_empty(line_edit):
		# Haal de tekst op en sla deze op in de variabele
		var user_input = line_edit.text
		print("LineEdit bevat tekst: ", user_input)
		return user_input
	else:
		print("LineEdit is leeg.")
		return ""  # Duidelijk aangeven dat er geen invoer is

func create_gemstone_object(game_key, gemstone_SN):
	gemstone_obj["available"] = 0
	gemstone_obj["connectionCloud"] = 1
	gemstone_obj["connectionGame"] = 1
	gemstone_obj["serialnr"] = gemstone_SN
	gemstone_obj["gameKey"] = game_key
	gemstone_obj["command"] = 0
	gemstone_obj["heartbeat"] = 0
	return gemstone_obj

# functie om de data die wordt verzonden samen te stellen
func create_payload():
	game_key = get_unix_timestamp()
	gemstone_SN = read_input()

	# Controleer of gemstone_SN een geldige waarde heeft
	if gemstone_SN == "":
		print("No valid entry for gemstone_SN. Connection not executed.")
		message.text = "No valid entry for gemstone_SN. Connection not executed."
		return  # Stop de functie hier
	else: 
		
		var payload = {"gameKey": game_key,
						"serialnr": gemstone_SN}
		print("Payload aangemaakt: ", payload)
		return payload

# verbindt de gemstone met de cloud
func connect_gemstone():
	var data = create_payload()
		# Controleer of data een geldige waarde heeft
	if data == null:
		message.text = "No valid value for gemstoneSN. Search not executed."
		return  # Stop de functie hier
	else: 
		send_post_request(data)
		line_edit.text = ""


func _on_post_button_pressed():
	connect_gemstone()
	


func _on_get_button_pressed():
	message.text = ""
	send_get_request()


func _on_back_button_pressed():
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	# Laad de nieuwe scène en stel deze in als de huidige scène
	get_tree().change_scene_to_file("res://scenes/levels/play_menu_test.tscn")
