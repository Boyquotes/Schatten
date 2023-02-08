extends TextureRect
onready var Tw = $Tween;


func _ready():
	interp_health(.7,4);
	pass

func interp_health(val:float, time:float):
	Tw.interpolate_property(material,"shader_param/fac",material.get("shader_param/fac"),clamp(val,0.0,1.0),time,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	Tw.start();
	

func set_health(val:float):
	material.set_shader_param("fac",clamp(val,0.0,1.0));
