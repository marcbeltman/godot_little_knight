extends Area2D

@onready var sound_wrong_door = $sound_wrong_door



func _on_body_entered(body):
	print("geraakt door player")
	sound_wrong_door.play()
