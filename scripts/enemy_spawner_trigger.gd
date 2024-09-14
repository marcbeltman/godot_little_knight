extends Area2D


func _ready():
	GameData.enemy_spawner = false


func _on_body_entered(body):
	print("ENEMY_SPAWNER TRIGGER HIT!!!")
	await get_tree().create_timer(2.0).timeout
	GameData.enemy_spawner = true
