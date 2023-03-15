extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	var Tw = $Tween
	Tw.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tw.start()
	yield(get_tree().create_timer(3), "timeout")
	Tw.interpolate_property(self, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tw.start()
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().change_scene("res://TitleScreen.tscn")
