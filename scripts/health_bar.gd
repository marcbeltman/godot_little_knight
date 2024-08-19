extends ProgressBar

var parent 
var max_value_amount
var min_value_amount

func _ready():
	parent = get_parent()
	max_value_amount = parent.health_max
	min_value_amount = parent.health_min
	
func _process(delta):
	self.value = parent.health
	# als health GEEN 100 % is laat dan healthbar zien
	if parent.health != max_value_amount:
		self.visible = true
		# als de health 0 % is verberg de healthbar
		if parent.health == min_value_amount: 
			self.visible = false 
	# als health 100 % is laat dan healthbar zien
	else:
		self.visible = false 
