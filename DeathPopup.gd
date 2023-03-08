extends Popup
onready var Tw = $Tween;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _deathPopup():
	popup()
	get_tree().paused = true

func _on_DeathPopup_about_to_show():
	Tw.interpolate_property(self, "modulate:a", 0.0, 1.0, 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tw.start()
	
func _input(event):
	if visible && event.is_action_pressed("attack"):
		get_tree().paused = false
		get_tree().change_scene("res://TitleScreen.tscn")
