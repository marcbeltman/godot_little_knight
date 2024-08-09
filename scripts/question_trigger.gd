extends Area2D

#declaratie signaal naar Dialogue
#signal player_hit(body)

@onready var dialogue_sound = $AudioStreamPlayer2D
var body_to_process: Node = null


func _on_body_entered(body):
	#dialogue_sound.finished.connect(Callable(self, "_on_dialogue_sound_finished"))
	dialogue_sound.play()
	print("Question_trigger: player hit")
	# Sla het body object op om het later te kunnen gebruiken
	#body_to_process = body
	var Dialogue_screen = get_node("/root/Game/Heads-Up_Display/Dialogue")
	Dialogue_screen.connect_question_trigger_signal(body)
	
	
	
	
func _on_dialogue_sound_finished():
		var Dialogue_screen = get_node("/root/Game/Heads-Up_Display/Dialogue")
		Dialogue_screen.connect_question_trigger_signal(body_to_process)
		body_to_process = null

	
	
	#var Dialogue_screen = get_node("/root/Game/Heads-Up_Display/Dialogue")
	#Dialogue_screen.connect_question_trigger_signal(body)
	



