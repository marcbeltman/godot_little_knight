extends Control

@onready var start_menu = preload("res://scenes/levels/menu.tscn") as PackedScene

var play_menu
var leaderboard_menu

func _ready():
	# Zoek de menu's opnieuw op als de scene geladen wordt
	play_menu = get_node("../Play_Menu")
	leaderboard_menu = get_node("../Leaderboard_Menu")
	
	# Controleer of beide menu's correct zijn geladen
	if play_menu == null:
		print("Error: Play menu is not correctly set up in the scene.")
	if leaderboard_menu == null:
		print("Error: Leaderboard menu is not correctly set up in the scene.")

func _on_button_back_pressed():
	print("Leaderboard_menu: back pressed")
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	#get_tree().change_scene_to_packed(start_menu)
	show_menu(play_menu)
	
func show_menu(menu_to_show: Control):
 	# Maak beide menus onzichtbaar
	play_menu.visible = false
	leaderboard_menu.visible = false
	# Laat alleen het gewenste menu zien
	menu_to_show.visible = true



