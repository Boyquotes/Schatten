extends MeshInstance

onready var bear_ref = preload("res://art/Boss/BearAnimElements/BearComposite.tscn").instance()

export var threshold = 5;
var base_scale = 1.0;
var max_scale = 15.0;

var kill_count = 0;
var spawned = false;

func spawn_bear():
	spawned = true;
	var par = get_parent();
	par.add_child(bear_ref);
	return;

func update_count():
	kill_count += 1;
	if kill_count < threshold:
		var fac = float(kill_count) / float(threshold)
		print(fac,"fac");
		set("scale",Vector3(fac * max_scale,1,fac * max_scale))
	if kill_count == threshold:
		spawn_bear();
	return;
