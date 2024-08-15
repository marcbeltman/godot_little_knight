extends CanvasLayer

@export var titel = " "
@export var question = " "
@export var answer_A = " "
@export var answer_B = " "
@export var answer_C = " "
@export var answer_D = " "

@export var right_answer = " "

@onready var audio_stream_player = $AudioStreamPlayer2D

const FILE_BEGIN = "res://scenes/levels/level_"

var dialog = []
var dialog_index = 0
var finished = false

func _ready():
	load_dialog()
	
func _process(delta):
	#$TextureRect/MarginContainer/RichTextLabel/NextIdicator.visible = finished
	if Input.is_action_just_pressed("dialog"):
		load_dialog()
		
		
func load_dialog():
	dialog = check_and_collect_strings()
	if dialog_index < dialog.size():
		$NinePatchRect/RichTextLabel.text = dialog[dialog_index]
		audio_stream_player.play()
		start_tween()
	else:
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		queue_free()
		next_level()
	
	dialog_index += 1
		
	
func start_tween():
	$TextureRect/MarginContainer/RichTextLabel.visible_ratio = 0
	# Create a SceneTreeTween instance
	var tween = create_tween()
	# Define the initial and final values for the property you want to tween
	var end_value = 1.0
	var duration = 1.0 # in seconds
	# Get the target node for tweening
	var target_node = $TextureRect/MarginContainer/RichTextLabel
	# Tween the property 'visible_ratio' of the target node
	tween.tween_property(target_node, "visible_ratio", end_value, duration)
	
func next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	print(current_scene_file)
	var next_level_number = current_scene_file.to_int() + 1
	print(next_level_number)
	var next_level_path = FILE_BEGIN + str(next_level_number) + ".tscn"
	print(next_level_path)
	get_tree().change_scene_to_file(next_level_path)

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
			assert(false, "Variable '%s' is an empty string or contains only whitespace" % name)
		else:
			result.append(value)

	return result

