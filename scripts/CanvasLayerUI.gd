extends CanvasLayer

@onready var countdown = $HBoxContainer/countdown
@onready var lives = $HBoxContainer/lives
@onready var score = $HBoxContainer/score



#@onready var timer = $Timer

#@onready var times_up = $TimesUp

#@export var playTime : int

##@export var redClr : Color
#@export var origClr : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	#timer.start()
	#OrigClrRet()
	$"../GameManager/Heath_System".lives_changed.connect(update_lives_text)
	%GameManager.score_changed.connect(update_score_text)
	%GameManager.countdown_updated.connect(update_countdown_text)
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#update_countdown_text()
	#if ceil(timer.time_left) < 7:
		#countdown.modulate = redClr
		#if not times_up.is_playing():
			#times_up.play()		
			
		#if ceil(timer.time_left) == 1:
			#print("tijd is op")
			#get_tree().reload_current_scene()
			
	#else: 
		#OrigClrRet()



#func OrigClrRet():
	#countdown.modulate = origClr

func update_countdown_text(time_left, color):
	#countdown.text = str(ceil(timer.time_left))
	countdown.text = str(time_left)
	countdown.modulate = color

	
func update_lives_text(current_lives):
	lives.text = str(current_lives)
	
	
func update_score_text(points):
	#print("update_score_text ", score_shit)
	score.text = str(points)
	

	
	
