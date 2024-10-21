extends Control

@onready var toy_menu = $"../Toy_Menu"
@onready var buy_menu = $"../Buy_Menu"


func _on_back_button_pressed():
	print("back-button pressed")
	show_menu(toy_menu)


func show_menu(menu_to_show: Control):
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
  
# Maak beide menus onzichtbaar
	toy_menu.visible = false
	buy_menu.visible = false
	
	# Laat alleen het gewenste menu zien
	menu_to_show.visible = true

