extends Spatial

onready var door = $"Door";
onready var tween = $"Tween";
onready var darken = $"Darken"

	
func rotate_door() -> void:
	tween.interpolate_property(self,"rotation_degrees",Vector3(0,90,0),Vector3(0,0,0),.5,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT);
	tween.start();


func end_game(body:Node):
	print(body.name)
	if body.name == "Player":
		body.in_cutscene = true;
		body.set("translation",$"Spatial".get_global_translation())
		body.vel_override = Vector3(7,0,0);
		yield(get_tree().create_timer(3), "timeout"); 
		var Tw = $Tween
		Tw.interpolate_property(darken, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		Tw.start()
		yield(get_tree().create_timer(1.5), "timeout")
		get_tree().change_scene("res://TitleScreen.tscn")
