extends CanvasLayer

@onready var countdown = $HBoxContainer/countdown
@onready var lives = $HBoxContainer/lives
@onready var score = $HBoxContainer/score


# Called when the node enters the scene tree for the first time.
func _ready():

	# laat de eventueel eerderbehaalde score zien
	score.text = str(GameData.score)
	
	$"../GameManager/Health_System".lives_changed.connect(update_lives_text)
	%GameManager.score_changed.connect(update_score_text)
	%GameManager.countdown_updated.connect(update_countdown_text)
	
	
func update_countdown_text(time_left, color):
	#countdown.text = str(ceil(timer.time_left))
	countdown.text = str(time_left)
	countdown.modulate = color

	
func update_lives_text(current_lives):
	lives.text = str(current_lives)
	
	
func update_score_text(points):
	#print("update_score_text ", score_shit)
	score.text = str(points)
	

	
	
