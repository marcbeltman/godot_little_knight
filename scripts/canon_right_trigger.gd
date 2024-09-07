extends Area2D


func _ready():
	GameData.canon_right_can_shoot = false


func _on_body_entered(body):
	print("CANON_RIGHT TRIGGER HIT!!!")
	#await get_tree().create_timer(0.3).timeout
	GameData.canon_right_can_shoot = true
