extends Control

#@onready var start_level = $Level1Menu  # Verwijzing naar het eerste menu in de scene
@onready var build_level = preload("res://scenes/levels/build_plan.tscn") as PackedScene
@onready var start_menu = $"../Start_Menu"
@onready var toy_menu = $"../Toy_Menu"
@onready var buy_menu = $"../Buy_Menu"


func _on_buy_button_pressed():
	print("buy-button pressed")
	show_menu(buy_menu)


func _on_build_button_pressed():
	print("build-button pressed")
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	get_tree().change_scene_to_packed(build_level)


func _on_back_button_pressed():
	print("back-button pressed")
	show_menu(start_menu)




func show_menu(menu_to_show: Control):
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
  
# Maak beide menus onzichtbaar
	start_menu.visible = false
	toy_menu.visible = false
	buy_menu.visible = false
	
	# Laat alleen het gewenste menu zien
	menu_to_show.visible = true










