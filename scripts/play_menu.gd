extends Control

#@onready var start_level = $Level1Menu  # Verwijzing naar het eerste menu in de scene
@onready var start_level = preload("res://scenes/levels/level_1.tscn") as PackedScene
#@onready var start_menu = $"."
#@onready var toy_menu = $"../Toy_Menu"
#var start_menu 
var toy_menu 
#var buy_menu
var play_menu

func _ready():
	# Zoek de menu's opnieuw op als de scene geladen wordt
	#start_menu = get_node(".")
	toy_menu = get_node("../Toy_Menu")
	#buy_menu = get_node("../Buy_Menu")
	play_menu = get_node("../Play_Menu")
	
		# Controleer of beide menu's correct zijn geladen
	#if start_menu == null:
		#print("Error: Start menu is not correctly set up in the scene.")
	if toy_menu == null:
		print("Error: Toy menu is not correctly set up in the scene.")
	#if toy_menu == null:
		#print("Error: Buy menu is not correctly set up in the scene.")
	if play_menu == null:
		print("Error: Play menu is not correctly set up in the scene.")
		
		
	# Zorg ervoor dat het startmenu zichtbaar is en het toymenu onzichtbaar
	#if  toy_menu != null and play_menu != null:
		#start_menu.visible = false
		toy_menu.visible = false
		#buy_menu.visible = false
		#play_menu.visible = false
		
	else:
		print("Error: One of the menus is not correctly set up in the scene.")


func _on_play_button_pressed():
	print("play pressed")
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	get_tree().change_scene_to_packed(start_level)

# Toy button pressed handler
func _on_toy_button_pressed():
	print("toy pressed")
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	show_menu(toy_menu)

func show_menu(menu_to_show: Control):
  
# Maak beide menus onzichtbaar
	#start_menu.visible = false
	toy_menu.visible = false
	play_menu.visible = false
	
	# Laat alleen het gewenste menu zien
	menu_to_show.visible = true




