extends Area2D


@onready var dialogue_sound = $AudioStreamPlayer2D
@onready var buid_tip: CanvasLayer = $"../../../../BuidTip"


var body_to_process: Node = null
var is_build_tip_open = false

func _ready():
	buid_tip.hide()


func _on_body_entered(body):
	print("Build_trigger: player hit")
	if !is_build_tip_open:
		_open_build_tip()


func _open_build_tip():
	dialogue_sound.play()
	buid_tip.show()
	is_build_tip_open = true
	
	
#func _close_build_tip():
	#buid_tip.hide()
	#is_build_tip_open = false
	

