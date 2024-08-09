class_name MainMenu
extends Control


@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level = preload("res://scenes/levels/level_1.tscn") as PackedScene

func _ready():
	start_button.button_down.connect(on_button_down)
	exit_button.button_down.connect(on_exit_pressed)


func on_button_down() -> void:
	# zet de transitie in. fade-out fade-in overgang ander level is een globale functie
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(start_level)


func on_exit_pressed() -> void:
	get_tree().quit()
	
