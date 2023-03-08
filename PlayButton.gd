extends TextureButton

func _on_PlayButton_pressed():
	print("Start game")
	get_tree().change_scene("res://Main.tscn")
