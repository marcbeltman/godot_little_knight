extends Node

#declaratie signaal naar the HUD 
signal score_changed(score)
signal countdown_updated(time_left)
# declaratie signaal naar healt system
signal countdown_player_died()

@export_group("points")
#@export var point_value: int = 10

@export_group("countdown") 
@export var duration: int = 50
@export var redClr : Color = Color(1.0, 0.0, 0.0) # Rood definiëren
@export var origClr : Color = Color(1.0, 1.1, 1.1) # Voorbeeld originele kleur

@onready var health_system = $Health_System
@onready var level_manager = $Level_Manager


@onready var countdown_timer = $CountdownTimer
@onready var times_up_sound = $TimesUp

# var voor de afgetelde seconden
var time_left = 0
# var voor de punten
var score = 0


func _ready():
	#zet de behaalde score uit GameData voor score default = 0
	score = GameData.score
	#print("De behaalde score uit GameData: ", score)
	# verbinding met heath system voor resetten countdown
	health_system.reset_countdown.connect(countdown_reset)
	level_manager.stop_countdown.connect(countdown_stop)
  	# Controleer of countdown_timer niet null is
	if countdown_timer:
	   # Verbind het timeout-signaal van de bestaande timer met de _on_timer_timeout functie
		countdown_timer.connect("timeout", Callable(self, "_on_timer_timeout"))
		# Start de countdown
		countdown_reset()
	else:
		print("Error: CountdownTimer node not found")


func _on_timer_timeout():
	#print ("countdown deactivated")
	countdown()


func countdown():
	time_left  -= 1  # Verminder de resterende tijd met 1 seconde
	var color_to_send = origClr

	if time_left  <= 5:
		if time_left > 0:
			color_to_send = redClr
		else:
			color_to_send = origClr

		if not times_up_sound.is_playing():
			times_up_sound.play()

		if time_left  == 0:
			print("tijd is op")
			emit_signal("countdown_player_died")

	else:
		color_to_send = origClr

	emit_signal("countdown_updated", time_left , color_to_send)
	#rint(time_left )
	if time_left  <= 0:
		countdown_timer.stop()  # Stop de timer wanneer de countdown voltooid is
		times_up_sound.stop()
		
func countdown_stop():
	print("countdown stop werd opgeroepen")
	countdown_timer.stop()

	
func countdown_reset():
	print("countdown reset werd opgeroepen") 
	time_left = duration
	countdown_timer.start()
	
func countdown_pause():
	print("countdown pause werd opgeroepen")
	time_left = time_left
	countdown_timer.stop()
	print("countdown_pause: ", time_left)
	
func countdown_resume():
	countdown_timer.start()
	print("coutdown_resume: ", time_left)

func add_point(point_value):
	score += point_value
	emit_signal("score_changed", score)

	





	
	
	

	

	
	
	
	


