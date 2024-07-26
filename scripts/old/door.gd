extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var open_door_sound = $AnimatedSprite2D/OpenDoorSound



func _on_body_entered(body):
	print("deur open")
	animated_sprite.play("open")
	open_door_sound.play()

