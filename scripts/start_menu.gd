extends Control

# Menu nodes
var start_menu
var play_menu
var leaderboard_menu
var toy_menu
var buy_menu

func _ready():
	# Zoek de menu's opnieuw op als de scene geladen wordt
	start_menu = get_node("/root/Menu/Start_Menu")
	play_menu = get_node("/root/Menu/Play_Menu")
	leaderboard_menu = get_node("/root/Menu/Leaderboard_Menu")
	toy_menu = get_node("/root/Menu/Toy_Menu")
	buy_menu = get_node("/root/Menu/Buy_Menu")

	# Controleer of elk menu correct is geladen
	if start_menu == null:
		print("Error: Start menu is not correctly set up in the scene.")
	if play_menu == null:
		print("Error: Play menu is not correctly set up in the scene.")
	if leaderboard_menu == null:
		print("Error: Leaderboard menu is not correctly set up in the scene.")
	if toy_menu == null:
		print("Error: Toy menu is not correctly set up in the scene.")
	if buy_menu == null:
		print("Error: Buy menu is not correctly set up in the scene.")
	
	# Zorg ervoor dat het startmenu zichtbaar is en de andere menus onzichtbaar
	if start_menu and play_menu and toy_menu and buy_menu and leaderboard_menu:
		start_menu.visible = true
		play_menu.visible = false
		toy_menu.visible = false
		buy_menu.visible = false
		leaderboard_menu.visible = false
	else:
		print("Error: One or more menus are not correctly set up in the scene.")


# Start button pressed handler
func _on_start_button_pressed():
	print("start pressed")
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	show_menu(play_menu)


func show_menu(menu_to_show: Control):
	# Controleer of alle menus zijn geladen voordat je hun zichtbaarheid aanpast
	if start_menu and play_menu and toy_menu and buy_menu and leaderboard_menu:
		# Maak alle menus onzichtbaar
		start_menu.visible = false
		play_menu.visible = false
		toy_menu.visible = false
		buy_menu.visible = false
		leaderboard_menu.visible = false

		# Laat alleen het gewenste menu zien
		menu_to_show.visible = true
	else:
		print("Error: One or more menus are not correctly set up in the scene.")


  
