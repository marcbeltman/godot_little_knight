extends Sprite2D


#@onready var player = get_parent().get_parent().get_node("World/player")

#@export var player_path : NodePath
#var player : Node2D


#func _ready():
	#if player_path:
		#player = get_node(player_path)
	#else:
		#print("CANON: Player path is not set!")



#func _process(delta):
	#if player:
		#look_at(player.global_position)
	#pass
