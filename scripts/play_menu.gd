extends Control

@onready var start_level = preload("res://scenes/levels/level_1.tscn") as PackedScene
@onready var line_edit = $MarginContainer/VBoxContainer2/LineEdit
@onready var message = $MarginContainer/VBoxContainer/Label_message

@onready var toy_menu = $"../Toy_Menu"
@onready var leaderboard_menu = $"../Leaderboard_Menu"
@onready var play_menu = $"."






#var toy_menu 
#var buy_menu
#var play_menu
#var leaderboard_menu

func _ready():
	# Zoek de menu's opnieuw op als de scene geladen wordt
	#toy_menu = get_node("../Toy_Menu")
	#play_menu = get_node("../Play_Menu")
	#leaderboard_menu = get_node("../Leaderboard_Menu")
	

	#play_menu = get_node("/root/Menu/Play_Menu")
	#leaderboard_menu = get_node("/root/Menu/Leaderboard_Menu")
	#toy_menu = get_node("/root/Menu/Toy_Menu")

	
	
	
	# message tekst is leeg
	message.text = ""
	
	# Controleer of de menu's correct zijn geladen
	if toy_menu == null:
		print("Error: Toy menu is not correctly set up in the scene.")
	if play_menu == null:
		print("Error: Play menu is not correctly set up in the scene.")
	if leaderboard_menu == null:
		print("Error: Lederboard menu is not correctly set up in the scene.")
		
		
	# Zorg ervoor dat het toy_menu onzichtbaar is 
	toy_menu.visible = false


func _on_play_button_pressed():
	print("play pressed")
	var player_name = line_edit.text
	if player_name == "":
		message.text = "please enter a playername!"
	elif contains_special_characters(player_name):
		message.text = "please remove special characters!"
	elif has_minimum_length(player_name, 3):
		message.text = "please use a longer playername!"
	else:
		GameData.player_name = player_name
		print("play_menu GameData.player_name: " , GameData.player_name)
		TransitionScreen.transition()  # Start de overgang
		await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
		get_tree().change_scene_to_packed(start_level)

# Toy button pressed handler
func _on_toy_button_pressed():
	print("toy pressed")
	message.text = ""
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	show_menu(toy_menu)

func _on_leaderboard_button_pressed():
	print("play_menu leaderboard_button pressed")
	message.text = ""
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	show_menu(leaderboard_menu)


func show_menu(menu_to_show: Control):
  
# Maak beide menus onzichtbaar
	toy_menu.visible = false
	play_menu.visible = false
	leaderboard_menu.visible = false
	# Laat alleen het gewenste menu zien
	menu_to_show.visible = true


func contains_special_characters(text: String) -> bool:
	var special_characters = "!@#$%^&*()+={}[]:\";'<>?,./\\|`~"
	
	for char in text:
		if char in special_characters:
			return true
	return false

func has_minimum_length(text: String, min_length: int) -> bool:
	return text.length() <= min_length



