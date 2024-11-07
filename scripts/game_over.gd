extends CanvasLayer


func _on_btn_retry_pressed():
	GameData.score = 0
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_btn_quit_pressed():
	#get_tree().quit()
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
