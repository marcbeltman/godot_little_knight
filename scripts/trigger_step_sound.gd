extends Area2D

@export var sound_effect: AudioStream
@onready var step_sound = $AudioStreamPlayer2D

func _on_body_entered(body):
	print("player hit")
	if sound_effect:
		var audio_player = AudioStreamPlayer2D.new()
		audio_player.stream = sound_effect
		audio_player.pitch_scale = 1.6
		audio_player.volume_db = 10 
		add_child(audio_player)
		audio_player.play()
