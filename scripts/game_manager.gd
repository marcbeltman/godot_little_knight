extends Node

#declaratie signaal naar the HUD en health system
signal score_changed(score)
signal countdown_updated(time_left)
signal countdown_player_died()

@export_group("points")
@export var point_value: int = 10

@export_group("countdown")
@export var time: int = 50
@export var redClr : Color = Color(1.0, 0.0, 0.0) # Rood definiëren
@export var origClr : Color = Color(1.0, 1.1, 1.1) # Voorbeeld originele kleur


@onready var timer = $Timer
@onready var times_up_sound = $TimesUp

#@onready var test_label = $"../GameManager/test_label"

var score = 0

func _ready():
	if timer and timer is Timer:
		print("Game manager: timer gevonden")
		# Binding creëren tussen countdown_time en timer.wait_time
		timer.wait_time = time
		print(timer.wait_time)
		timer.start()


func _process(delta):
	#update_countdown_text()
	var time_left = ceil(timer.time_left)
	
	#print("Time left: ", time_left)  # Debug print om tijd te controleren

	var color_to_send = origClr
	if time_left <= 8:
		if time_left > 1:
			#print("Changing color to red")  # Debug print
			#test_label.modulate = redClr
			color_to_send = redClr
		else:
			#print("Changing color to original")  # Debug print
			#test_label.modulate = origClr
			color_to_send = origClr
		
		if not times_up_sound.is_playing():
			times_up_sound.play()
		
		if time_left == 1:
			print("tijd is op")
			emit_signal("countdown_player_died")
			reset_timer()
	else:
		#test_label.modulate = origClr
		color_to_send = origClr
	# Stuur het signaal uit met de huidige timer waarde
	emit_signal("countdown_updated", time_left, color_to_send)



#func OrigClrRet():
	#test_label.modulate = origClr

#func update_countdown_text():
	#test_label.text = str(ceil(timer.time_left))

func reset_timer():
	timer.stop()  # Stop de timer
	timer.wait_time = time  # Stel de tijd opnieuw in
	timer.start()  # Start de timer opnieuw









func add_point():
	score += point_value
	emit_signal("score_changed", score)

	
	
	
	


