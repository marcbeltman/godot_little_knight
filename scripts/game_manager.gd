extends Node

var score = 0
@onready var score_label = $ScoreLabel

#declaratie signaal naar the HUD
signal score_changed(score)


func add_point():
	score += 10
	#score_label.text = "You collected " + str(score) + " coins."
	emit_signal("score_changed", score)
