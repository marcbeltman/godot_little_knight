extends Control


func _on_buy_button_pressed():
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	# Laad de nieuwe scène en stel deze in als de huidige scène
	get_tree().change_scene_to_file("res://scenes/levels/buy_menu_test.tscn")


func _on_build_button_pressed():
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	# Laad de nieuwe scène en stel deze in als de huidige scène
	get_tree().change_scene_to_file("res://scenes/levels/build_plan.tscn")


func _on_back_button_pressed():
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	# Laad de nieuwe scène en stel deze in als de huidige scène
	get_tree().change_scene_to_file("res://scenes/levels/play_menu_test.tscn")
