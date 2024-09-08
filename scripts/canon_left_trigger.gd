extends Area2D


func _ready():
	GameData.canon_left_can_shoot = false


func _on_body_entered(body):
	print("CANON_LEFT TRIGGER HIT!!!")
	#await get_tree().create_timer(0.3).timeout
	GameData.canon_left_can_shoot = true
