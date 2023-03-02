extends TextureRect
onready var Tw = $Tween;

func _ready():
	var player = get_node("/root/Main/Player")
	player.connect("health_changed", self, "_on_Player_health_changed")

func _on_Player_health_changed(healthVal):
	var newHealth = healthVal / 100.0
	print(newHealth)
	interp_health(newHealth, 2)
	# set_health(newHealth)

func interp_health(val:float, time:float):
	Tw.interpolate_property(material,"shader_param/fac",material.get("shader_param/fac"),clamp(val,0.0,1.0),time,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
	Tw.start();
	

func set_health(val:float):
	material.set_shader_param("fac",clamp(val,0.0,1.0));
