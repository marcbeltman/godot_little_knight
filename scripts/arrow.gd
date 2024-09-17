extends CharacterBody2D

class_name Arrow

@export var speed = 200
@export var damage = 15

# area2d collisionshape om schade aan vijand te geven
@onready var deal_damage_zone = $arrow_deal_damage_area


var direction: Vector2

# delete arrow after x time
func _ready():
	await get_tree().create_timer(3).timeout
	queue_free()


func set_direction(arrowDirection):
	direction = arrowDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position + direction))

func _physics_process(delta):
	global_position += direction * speed * delta
	
	GameData.arrowDamageAmount = damage
	GameData.arrowDamageZone = deal_damage_zone
	


func _on_arrow_deal_damage_area_body_entered(body):
	if body is TileMap or body is BatEnemy or body is DwarfEnemy or body is Rockblock:
		#print(body)
		queue_free()
