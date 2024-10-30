extends Area2D


@onready var audio_stream_player = $AudioStreamPlayer2D
var has_played_sound = false


func _ready():
	GameData.rock_is_falling = false

func _on_body_entered(body):
	print("ROCK_TRIGGER: PLAYER TRIGGER HIT!!!")
	if not has_played_sound:
		audio_stream_player.play()
		has_played_sound = true
	await get_tree().create_timer(1.2).timeout
	GameData.rock_is_falling = true


