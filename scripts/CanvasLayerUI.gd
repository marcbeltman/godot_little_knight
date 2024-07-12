extends CanvasLayer

@onready var countdown = $countdown
@onready var timer = $Timer

@onready var times_up = $TimesUp


@export var redClr : Color
@export var origClr : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()
	OrigClrRet()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_countdown_text()
	if ceil(timer.time_left) < 7:
		countdown.modulate = redClr
		if not times_up.is_playing():
			times_up.play()		
			
		if ceil(timer.time_left) == 1:
			print("tijd is op")
			
			get_tree().reload_current_scene()
			
	else: 
		OrigClrRet()
		
	
		

func OrigClrRet():
	countdown.modulate = origClr


func update_countdown_text():
	countdown.text = str(ceil(timer.time_left))
	
func test():
	print("klote")
	

	
	
