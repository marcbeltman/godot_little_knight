extends StaticBody2D

class_name Rockblock

@export var health := 150

@onready var rock_destroy = $rock_destroy
#@onready var signal_connected = rock_destroy.animation_finished.connect(_on_animation_finished)
@onready var rock_block = $"."
@onready var audio_stream_player = $explosion_big
@onready var explosion_small = $explosion_small


var health_max = health
var health_min = 0
var dead : bool = false
var taking_damage : bool = false



func _on_rock_block_deal_damage_area_area_entered(area):
	print("ROCKBLOCK: arrow hit!!!", area )
	if area == GameData.arrowDamageZone:
		explosion_small.play()
		var damage = GameData.arrowDamageAmount
		take_damage(damage)
	
	
func take_damage(damage):
	health -= damage
	taking_damage = true
	if health <= 0:
		health = 0
		dead = true
		rock_destroy.play("rock_destroy")
		audio_stream_player.play()
		await get_tree().create_timer(1.3).timeout
		rock_block.visible = false
		await get_tree().create_timer(1.3).timeout
		queue_free()
	print(str(self), "current health is ", health)
	


