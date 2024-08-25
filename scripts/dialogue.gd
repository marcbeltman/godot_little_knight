extends CanvasLayer

@export var titel = " "
@export var question = " "
@export var answer_A = " "
@export var answer_B = " "
@export var answer_C = " "
@export var answer_D = " "

@export var right_answer = " "

@onready var game_manager = %GameManager
@onready var typing_timer = $Timer
@onready var label = $"NinePatchRect/RichTextLabel"

var player = null

var dialog = []
var dialog_index = 0
var finished = false

var full_text = ""
var current_index = 0
var typing_speed = 0.01  # Interval in seconds between each character was 0.07

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
	
func show_next_dialog():
	if dialog_index < dialog.size():
		full_text = dialog[dialog_index]
		current_index = 0

		if dialog_index == 1:  # Assuming the question is the second item in the dialog array
			label.text = full_text  # Show the question in one go
			typing_timer.stop()
			dialog_index += 1  # Move to the next dialog
		else:
			label.text = ""
			typing_timer.start(typing_speed)
			start_tween()
			dialog_index += 1  # Move to the next dialog after processing the current one
	else:
		print("Einde dialoog")
		finished = true
		self.visible = false
		# start de countdown in de hud opnieuw
		%GameManager.countdown_resume()
		if player:
			player.set_physics_process(true)
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
		label.text += full_text[current_index]
		current_index += 1
		if current_index >= full_text.length():
			typing_timer.stop()
		else:
			typing_timer.start(typing_speed)
	else:
		typing_timer.stop()

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
	player.set_physics_process(false)
	self.visible = true
	load_dialog()
