extends Area2D

@onready var game_manager = %GameManager
@onready var dialogue_sound = $AudioStreamPlayer2D
var body_to_process: Node = null


func _on_body_entered(body):
	dialogue_sound.play()
	print("Question_trigger: player hit")
	var Dialogue_screen = get_node("/root/Game/Heads-Up_Display/Instructions")
	Dialogue_screen.connect_question_trigger_signal(body)
	%GameManager.countdown_pause()
	
	
func _on_dialogue_sound_finished():
		var Dialogue_screen = get_node("/root/Game/Heads-Up_Display/Instructions")
		Dialogue_screen.connect_question_trigger_signal(body_to_process)
		body_to_process = null
		

	
