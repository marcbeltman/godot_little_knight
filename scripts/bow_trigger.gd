extends Area2D

@onready var arrow_sprite = $Sprite2D
@onready var arrow_sound = $AudioStreamPlayer2D
@onready var collision_shape = $CollisionShape2D

func _ready():
	GameData.bow_equip = false
	arrow_sprite.visible = true


func _on_body_entered(body): 
	print("Bow_trigger: player hit")
	arrow_sound.play()
	arrow_sprite.visible = false
	GameData.weapon_equip = false
	GameData.bow_equip = true
	arrow_sound.finished.connect(_on_sound_finished)


	
	
	
func _on_sound_finished():
	queue_free()
	
