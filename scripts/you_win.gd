extends Control

@onready var label_score = $MarginContainer/VBoxContainer/Label_score



# Called when the node enters the scene tree for the first time.
func _ready():
	label_score.text = str(GameData.score)


