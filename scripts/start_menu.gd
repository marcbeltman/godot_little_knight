extends Control

var start_menu 
var play_menu
var toy_menu
var buy_menu

func _ready():
	
	# Zoek de menu's opnieuw op als de scene geladen wordt
	start_menu = get_node(".")
	play_menu = get_node("../Play_Menu")
	toy_menu = get_node("../Toy_Menu")
	buy_menu = get_node("../Buy_Menu")
		
		# Controleer of beide menu's correct zijn geladen
	if start_menu == null:
		print("Error: Start menu is not correctly set up in the scene.")
	if play_menu == null:
		print("Error: Play menu is not correctly set up in the scene.")
		
	# Zorg ervoor dat het startmenu zichtbaar is en de andere menus onzichtbaar
	if start_menu != null and play_menu != null:
		start_menu.visible = true
		play_menu.visible = false
		toy_menu.visible = false
		buy_menu.visible = false
		
		
	else:
		print("Error: One of the menus is not correctly set up in the scene.")


# Start button pressed handler
func _on_start_button_pressed():
	print("start pressed")
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	show_menu(play_menu)


func show_menu(menu_to_show: Control):
# Maak beide menus onzichtbaar
	start_menu.visible = false
	play_menu.visible = false
	toy_menu.visible = false
	buy_menu.visible = false
		
	# Laat alleen het gewenste menu zien
	menu_to_show.visible = true



  
