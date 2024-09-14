extends AnimatableBody2D


# Verander deze variabelen naar wens
@export var blink_interval: float = 0.5 # Tijd in seconden tussen knipperen
@export var move_amount: float = 150.0  # Totale afstand naar rechts
@export var move_speed: float = 175.0   # Snelheid in pixels per seconde

# Variabelen voor het bijhouden van de tijd en knipperstatus
var time_since_last_blink: float = 0.0
var sprite: Sprite2D
var is_visible: bool = true
var is_blinking: bool = false

var target_position: Vector2
var is_moving: bool = false

@onready var area_2d = $Area2D


func _ready():
	GameData.platform_escape_blink = false
	# Zorg ervoor dat de sprite wordt gevonden
	sprite = $Sprite2D
	if sprite == null:
		push_error("Sprite2D not found as a child of this node.")
	
	# Initialiseer zichtbaarheid
	sprite.visible = true

	# Stel de startpositie in en schakel beweging uit
	target_position = self.position
	is_moving = false


func _on_area_2d_body_entered(body):
	if body is Player and GameData.platform_escape_blink:
		GameData.bow_equip = false
		print("ESCAPE_PLATFORM: enemies dead player hit platform!!!")
		GameData.platform_escape_blink = false
		print("platform_escape_blink uitgeschakeld: ", GameData.platform_escape_blink)
		# Stel de doelpositie in op de huidige positie + de verplaatsingshoeveelheid
		target_position = self.position + Vector2(move_amount, 0)
		is_moving = true  # Zet de beweging aan
		var child_node = area_2d
		child_node.queue_free()



func _process(delta: float):
	#print("platform_escape_blink:", GameData.platform_escape_blink)
	if GameData.platform_escape_blink:
		if not is_blinking:
			# Start knipperen
			is_blinking = true
			time_since_last_blink = 0.0
			sprite.visible = true # Zorg ervoor dat de sprite zichtbaar is aan het begin van het knipperen
		
		# Tijd bijhouden en knipperen
		time_since_last_blink += delta

		if time_since_last_blink >= blink_interval:
			is_visible = !is_visible
			sprite.visible = is_visible
			time_since_last_blink = 0.0
	else:
		# Stop knipperen en maak de sprite zichtbaar
		if is_blinking:
			sprite.visible = true # Zorg ervoor dat de sprite zichtbaar is wanneer het knipperen stopt
			is_blinking = false

	# Aansturen van de verplaatsing als het platform in beweging is
	if is_moving:
		move_platform_right(delta)


# Functie om het platform geleidelijk naar rechts te verplaatsen
func move_platform_right(delta: float):
	# Beweeg de huidige positie richting de doelpositie
	self.position = self.position.lerp(target_position, move_speed * delta / move_amount)
	# Controleer of het platform dicht genoeg bij de doelpositie is om te stoppen
	if self.position.distance_to(target_position) < 1.0:
		self.position = target_position  # Maak de positie precies gelijk aan de doelpositie
		is_moving = false  # Beweging stoppen



