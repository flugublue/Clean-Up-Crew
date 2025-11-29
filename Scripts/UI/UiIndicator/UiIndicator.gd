extends MarginContainer

@export var indicator_Texture : TextureRect

var images_Indicators : Dictionary = {
	"Default"        : "res://Assets/Ui/Img/Indicators/Default/DefaultIndicator.png",
	"Grabbable"           : "res://Assets/Ui/Img/Indicators/Grab/GrabIndicator.png",
	"Holding"      : "res://Assets/Ui/Img/Indicators/Holding/HoldingIndicator.png",
}

func _ready() -> void:
	GlobalSignals.player_indicator.connect(_load_new_indicator)
	
func _load_new_indicator(indicator_Needed : String) -> void: 
	if indicator_Needed in images_Indicators:
		indicator_Texture.texture = load(images_Indicators[indicator_Needed])

	else: 
		print("Error : Tried loading a non existant image : ", indicator_Needed)
