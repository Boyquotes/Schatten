extends TextureButton

func _on_CreditsButton_pressed():
	get_tree().paused = true
	$"../CreditsPopup".popup()
