extends TextureButton

@onready var build_tip = get_node("/root/Game/BuidTip")
@onready var build_trigger = $"../../../World/Objects/Triggers/build_trigger"

func _on_pressed():
	print("button is geklikt")
	build_tip.hide()
	build_trigger.hide()
