extends Popup
onready var Tw = $Tween;


func _on_CreditsPopup_about_to_show():
	Tw.interpolate_property(self, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	Tw.start()

func _input(event):
	if visible && (event.is_action_pressed("attack") || event.is_action_pressed("ui_cancel")):
		Tw.interpolate_property(self, "modulate:a", 1.0, 0.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		Tw.start()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().paused = false
		hide()
	
