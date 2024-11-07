extends Control


@onready var label_score = $MarginContainer/VBoxContainer/Label_score

# Called when the node enters the scene tree for the first time.
func _ready():
	label_score.text = str(GameData.score)

func _on_button_leaderboard_pressed():
	print("level 6 button back pressed")
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	# Laad de nieuwe scène en stel deze in als de huidige scène
	get_tree().change_scene_to_file("res://scenes/levels/lederboard_menu_test.tscn")


func _on_button_back_pressed():
	print("level 6 button back pressed")
	TransitionScreen.transition()  # Start de overgang
	await TransitionScreen.on_transition_finished  # Wacht tot de overgang klaar is
	# Laad de nieuwe scène en stel deze in als de huidige scène
	get_tree().change_scene_to_file("res://scenes/levels/play_menu_test.tscn")




