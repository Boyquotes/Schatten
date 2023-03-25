extends Spatial

onready var door = $"Pivot";
onready var tween = $"Tween";
onready var darken = $"Darken"
var rotated:bool = false;

	
func rotate_door() -> void:
	if !rotated:
		rotated = true;
		tween.interpolate_property(door,"rotation_degrees",Vector3(0,90,0),Vector3(0,0,0),.5,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT);
		tween.interpolate_property(door,"translation",door.get("translation"),door.get("translation") + Vector3(0,0,.4),.5,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT);
		tween.start();


func end_game(body:Node):
	if body.name == "Player":
		body.in_cutscene = true;
		body.set("translation",$"Spatial".get_global_translation())
		body.vel_override = Vector3(7,0,0);
		#The velocity override seems like it may not be workinig correctly.
		yield(get_tree().create_timer(3), "timeout"); 
		var Tw = $Tween
		Tw.interpolate_property(darken, "modulate:a", 0.0, 1.0, 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		Tw.start()
		yield(get_tree().create_timer(1.5), "timeout")
		get_tree().change_scene("res://TitleScreen.tscn")
