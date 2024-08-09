extends CanvasLayer

@export var titel = " "
@export var question = " "
@export var answer_A = " "
@export var answer_B = " "
@export var answer_C = " "
@export var answer_D = " "

@export var right_answer = " "

@onready var typing_sound = $AudioStreamPlayer2D
@onready var typing_timer = $Timer
@onready var label = $"NinePatchRect/RichTextLabel"

var player = null

var dialog = []
var dialog_index = 0
var finished = false

var full_text = ""
var current_index = 0
var typing_speed = 0.07  # Interval in seconds between each character


func _ready():
	typing_timer.connect("timeout", Callable(self, "_on_typing_timeout"))
	load_dialog()
	self.visible = false
	typing_timer.stop()

func _process(delta):
	#$"NinePatchRect/next-indicator".visible = finished
	if Input.is_action_just_pressed("dialog") and not finished:
		show_next_dialog()

func load_dialog():
	dialog = check_and_collect_strings()
	dialog_index = 0  # Reset dialog_index
	finished = false  # Reset finished
	show_next_dialog()
	  # Laad de eerste dialoog zonder het geluid af te spelen
	#if dialog.size() > 0:
		#full_text = dialog[dialog_index]
		#label.text = ""
		#typing_timer.start(typing_speed)
		#typing_sound.play()
		#start_tween()
	

func show_next_dialog():
	if dialog_index < dialog.size():
		#$NinePatchRect/RichTextLabel.text = dialog[dialog_index]
		
		full_text = dialog[dialog_index]
		current_index = 0
		label.text = ""
		typing_timer.start(typing_speed)
		#typing_sound.play()
		
		start_tween()
		dialog_index += 1
	else:
		print("Einde dialoog")
		finished = true
		# Verberg het CanvasLayer wanneer de dialoog is afgelopen
		self.visible = false
		# herstart de controls player 
		#player.set_physics_process(true)
		# zet de global var player weer op null
		#player = null
		if player:
			player.set_physics_process(true)
		# Zet de global var player weer op null
		player = null

func start_tween():
	
	$NinePatchRect/RichTextLabel.visible_ratio = 0
	var tween = create_tween()
	var end_value = 1.0
	var duration = 1.0
	var target_node = $NinePatchRect/RichTextLabel
	tween.tween_property(target_node, "visible_ratio", end_value, duration)




func _on_typing_timeout():
	if current_index < full_text.length():
		# Start een timer voor de vertraging van het typgeluid
		print("te vroeg")
		typing_sound.play()
		label.text += full_text[current_index]
		current_index += 1
		if current_index >= full_text.length():
			typing_timer.stop()
			typing_sound.stop()
		else:
			# Restart the timer to continue typing
			typing_timer.start(typing_speed)
	else:
		typing_timer.stop()
		typing_sound.stop()





func check_and_collect_strings() -> Array:
	var result = []
	var variables = {
		"titel": titel,
		"question": question,
		"answer_A": answer_A,
		"answer_B": answer_B,
		"answer_C": answer_C,
		"answer_D": answer_D
	}
	
	for name in variables.keys():
		var value = variables[name]
		if value.strip_edges() == "":
			print("Error: Variable '%s' is an empty string or contains only whitespace" % name)
			assert(false, "Variable '%s' is een lege string of bevat alleen spaties" % name)
		else:
			result.append(value)

	return result

func connect_question_trigger_signal(body):
	print("Dialogue: signaal van question_trigger aangekomen", body)
	player = body
	# stop controls player 
	player.set_physics_process(false)
	# Maak het CanvasLayer zichtbaar wanneer de functie wordt aangeroepen
	self.visible = true
	# Reset de dialoog en begin opnieuw
	load_dialog()
