extends KinematicBody

onready var boss_anim_tree = get_node("AnimationTree");
onready var boss_states = boss_anim_tree["parameters/playback"];
onready var player = $"/root/Main/Player";
onready var pause_timer = $"PauseTimer"
onready var game_rig_parent = $"Node";
onready var bear_hit = $"Bear_hit";
onready var tween = $"Tween";
onready var particles = $"BossParticles";
onready var bear_mesh = $"Node/Node/Skeleton/bear1"



export var speed = 1;
var dir = Vector3(1,0,1);
var swinging = false;
var swing_threshold = 5.0;

#speed fac will makes the speed manageable
export var speed_fac = 0.25;
var dist = 20;

#damage to player
export var damage = 15;

#damage to bear
export var health_dec = 20;
export var health = 100;

var dead = false;


#
##wrap the swing functionality
func swing():
	boss_states.travel("Swing");
	swinging = true;
	yield(get_tree().create_timer(.2), "timeout");
	swinging = false;

##makes sure the bear does not lean but looks and moves
func _physics_process(delta):
	if !dead:
		var player_loc = player.get("translation");
		look_at(player_loc, Vector3.UP)
		set("rotation.x",0);
		set("rotation.z",0)
		if !swinging && (dist > swing_threshold):
			move_and_collide(dir.normalized() * speed_fac,false);

#
##this timer makes decisions for the bear periodically because on tick is too fast
func _on_Timer_timeout():
	if !dead:
		dir = player.get_global_translation () - get_global_translation()
		dir.y = 0;
		speed_fac = rand_range(0.2,0.75) / 4;
		dist = abs(dir.length());
		if !swinging && (abs(dist) <= swing_threshold):
			swing();




func _on_Area_body_entered(body):
	if !dead:
		if body.name == "Player" && swinging:
			player.take_damage(damage);

func take_damage()->void:
	if health > 0:
		health -= health_dec;
		game_rig_parent.set("visible",false);
		bear_hit.set("visible",true);
		bear_hit.get_child(1).play("BearHit");
		yield(get_tree().create_timer(.5), "timeout");
		bear_hit.set("visible",false);
		game_rig_parent.set("visible",true);
	if health <= 0 and !dead:
		dead = true;
		#Bear death
		set("transform.y",0.2)
		boss_anim_tree.set("active",false);
		particles.set("emitting",true);
		var rot = get("rotation_degrees");
		rot.x = 90;
		tween.interpolate_property(self,"rotation_degrees",get("rotation_degrees"),rot,.3,Tween.TRANS_CUBIC,Tween.EASE_OUT);
		tween.start();
		yield(get_tree().create_timer(.5), "timeout");
		tween.interpolate_property(self,"scale",Vector3(1,1,1),Vector3(.4,.4,.4),2.2,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT);
		tween.start()
		yield(get_tree().create_timer(1.2), "timeout");
		particles.set("emitting",false)
		print(bear_mesh.get_surface_material(0).albedo_color);
		bear_mesh.get_surface_material(0).albedo_color = Color(214.0/256.0,140.0/256.0,83.0/256.0,1.0);
		$"..".to_spawn = false;
		#queue_free();
