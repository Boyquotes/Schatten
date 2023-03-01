extends TextureButton

func _on_TextureButton_pressed():
	$"../..".hide()
	get_tree().paused = false
