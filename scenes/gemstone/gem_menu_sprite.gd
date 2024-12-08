extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# animatie gemstone sprite
	var tween = create_tween().set_loops()
	# Schaal klein
	tween.tween_property(self, "scale", Vector2(0.7, 0.7), 0.8)
	# Schaal groot
	tween.tween_property(self, "scale", Vector2(0.9, 0.9), 0.8)
