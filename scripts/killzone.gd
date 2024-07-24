extends Area2D

#declaratie signaal naar Health_System
signal player_died(body)

func _on_body_entered(body):
	die(body)
	
func die(body):
	# verzenden signaal naar Health_System
	player_died.emit(body)
