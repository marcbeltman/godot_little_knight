extends Control

#@onready var start_level = $Level1Menu  # Verwijzing naar het eerste menu in de scene
@onready var start_level = preload("res://scenes/levels/level_1.tscn") as PackedScene
#@onready var start_menu = $"."
#@onready var toy_menu = $"../Toy_Menu"
var start_menu 
var toy_menu 
var buy_menu

func _ready():
	# Zoek de menu's opnieuw op als de scene geladen wordt
	start_menu = get_node(".")
	toy_menu = get_node("../Toy_Menu")
	buy_menu = get_node("../Buy_Menu")
	
		# Controleer of beide menu's correct zijn geladen
	if start_menu == null:
		print("Error: Start menu is not correctly set up in the scene.")
	if toy_menu == null:
		print("Error: Toy menu is not correctly set up in the scene.")
	if toy_menu == null:
		print("Error: Buy menu is not correctly set up in the scene.")
		
	# Zorg ervoor dat het startmenu zichtbaar is en het toymenu onzichtbaar
	if start_menu != null and toy_menu != null and buy_menu != null:
		start_menu.visible = true
		toy_menu.visible = false
		buy_menu.visible = false
	else:
		print("Error: One of the menus is not correctly set up in the scene.")


# Start button pressed handler
func _on_start_button_pressed():
	print("start pressed")
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	get_tree().change_scene_to_packed(start_level)

# Toy button pressed handler
func _on_toy_button_pressed():
	print("toy pressed")
	show_menu(toy_menu)

func show_menu(menu_to_show: Control):
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
  
# Maak beide menus onzichtbaar
	start_menu.visible = false
	toy_menu.visible = false
	
	# Laat alleen het gewenste menu zien
	menu_to_show.visible = true



  
