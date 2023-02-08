extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _button_pressed():
	pass

func _on_Button_pressed():
	print("Start game")
	get_tree().change_scene("res://Main.tscn")
