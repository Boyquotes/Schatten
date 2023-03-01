extends TextureButton

func _on_TextureButton_pressed():
	print("Continue")
	$"../..".hide()
	get_tree().paused = false
