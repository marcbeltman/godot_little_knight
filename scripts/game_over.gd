extends CanvasLayer


func _on_btn_retry_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_btn_quit_pressed():
	get_tree().quit()
