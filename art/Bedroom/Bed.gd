extends Spatial
onready var tween = $"Tween";

export var rot = 120
export var dist = 10
export var time = .3;
var easing = Tween.TRANS_QUAD;


func flip(wait_time:float = 0.0) -> void:
	yield(get_tree().create_timer(wait_time), "timeout"); 
	tween.interpolate_property(self,"translation",get("translation"),get("translation") + Vector3(0,0,-1 * dist),time,easing,tween.EASE_IN);
	tween.interpolate_property(self,"rotation_degrees",get("rotation_degrees"),get("rotation_degrees") + Vector3(0,0,rot),time,easing,tween.EASE_IN);
	tween.start();
