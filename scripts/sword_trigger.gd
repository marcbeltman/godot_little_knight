extends Area2D

@onready var sword_sprite = $Sprite2D
@onready var sword_sound = $AudioStreamPlayer2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	GameData.weapon_equip = false
	sword_sprite.visible = true


func _on_body_entered(body): 
	print("Sword_trigger: player hit")
	sword_sound.play()
	sword_sprite.visible = false
	GameData.bow_equip = false
	GameData.weapon_equip = true
	sword_sound.finished.connect(_on_sound_finished)
	
	
func _on_sound_finished():
	queue_free()
	
