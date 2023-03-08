extends MeshInstance

onready var bear_ref = preload("res://art/Boss/BearAnimElements/BearComposite.tscn").instance()
onready var particles = $"../CPUParticles"
onready var timer = $"../Timer"

export var threshold = 2;
var base_scale = 1.0;
var max_scale = 15.0;

var kill_count = 0;
var spawned = false;




func spawn_bear():
	spawned = true;
	var par = get_parent();
	par.add_child(bear_ref);
	spawned = true
	set("visible",false)
	return;

func update_count():
	if !spawned:
		particles.set("emitting",true);
		timer.start();
	kill_count += 1;
	if kill_count < threshold:
		var fac = float(kill_count) / float(threshold)
		print(fac,"fac");
		set("scale",Vector3(fac * max_scale,1,fac * max_scale))
	if kill_count == threshold:
		spawn_bear();
	return;


func _on_Timer_timeout():
	particles.set("emitting",false);
