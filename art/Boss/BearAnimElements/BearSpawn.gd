extends MeshInstance

onready var bear_flip_ref = preload("res://art/Boss/BearAnimElements/BearBedFlip.tscn").instance()
onready var bear_ref = preload("res://art/Boss/BearAnimElements/BearComposite.tscn").instance();
onready var timer = $"../Timer"
onready var bed_ref = $"../../Bed2"

export var threshold = 3;
var base_scale = 1.0;
var max_scale = 15.0;

var kill_count = 0;
var spawned = false;




func _ready():
	threshold = floor(rand_range(threshold-2,threshold+2));

func spawn_bear():
	spawned = true;
	var par = get_parent().get_parent();
	par.add_child(bear_flip_ref);
	spawned = true
	set("visible",false)
	bed_ref.flip(7.5)
	bear_flip_ref.flip();
	yield(get_tree().create_timer(8.0), "timeout"); 
	bear_ref.set("translation",bear_flip_ref.placeholder.get_global_transform().origin);
	#spews out errors here, and either moves too fast or is not spawning in the right place
	bear_flip_ref.queue_free();
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

