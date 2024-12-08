extends Control

@onready var line_edit = $MarginContainer/VBoxContainer2/LineEdit
@onready var message = $MarginContainer/VBoxContainer/Label_message


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
		# Laad de nieuwe scène en stel deze in als de huidige scène
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_leaderboard_button_pressed():
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	# Laad de nieuwe scène en stel deze in als de huidige scène
	get_tree().change_scene_to_file("res://scenes/levels/lederboard_menu_test.tscn")
	
	
func _on_toy_button_pressed():
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	# Laad de nieuwe scène en stel deze in als de huidige scène
	get_tree().change_scene_to_file("res://scenes/levels/toy_menu_test.tscn")


func contains_special_characters(text: String) -> bool:
	var special_characters = "!@#$%^&*()+={}[]:\";'<>?,./\\|`~"
	
	for char in text:
		if char in special_characters:
			return true
	return false

func has_minimum_length(text: String, min_length: int) -> bool:
	return text.length() <= min_length


func _on_gemstone_button_pressed():
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	# Laad de nieuwe scène en stel deze in als de huidige scène
	get_tree().change_scene_to_file("res://scenes/levels/gemstone_menu_test.tscn")
