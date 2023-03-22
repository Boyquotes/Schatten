extends Spatial

onready var door = $"Door";
onready var tween = $"Tween";

	
func rotate_door() -> void:
	tween.interpolate_property(self,"rotation_degrees",Vector3(0,0,0),Vector3(0,90,0),.5,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT);
	tween.start();


func end_game(body:Node):
	get_tree().change_scene("res://TitleScreen.tscn")
