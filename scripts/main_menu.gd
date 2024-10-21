extends Control

@onready var start_level = preload("res://scenes/levels/level_1.tscn") as PackedScene
@onready var toy_menu = preload("res://scenes/levels/toy_menu.tscn") as PackedScene
@onready var current_menu = self  # Keep track of the current menu

# This function will handle switching between scenes
func switch_menu(new_scene: PackedScene):
	TransitionScreen.transition()  # Start transition
	await TransitionScreen.on_transition_finished  # Wait for transition to finish
	
	# Check if the new scene is different from the current one
	if current_menu != new_scene:
		# Replace the current scene with the new one
		get_tree().change_scene_to_packed(new_scene)
		current_menu = new_scene  # Update the reference to the new scene




func _on_start_button_pressed():
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	#get_tree().change_scene_to_packed(start_level)
	print("start pressed")
	switch_menu(start_level)


func _on_toy_button_pressed():
	#TransitionScreen.transition()
	#await TransitionScreen.on_transition_finished
	#get_tree().change_scene_to_packed(toy_menu)
	print("toy pressed")
	switch_menu(toy_menu)
