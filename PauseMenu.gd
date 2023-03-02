extends Popup

var is_shown = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		is_shown = !is_shown
		if !is_shown:
			hide()
			get_tree().paused = false
		else:
			get_tree().paused = true
			show()
