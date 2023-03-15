extends KinematicBody

onready var boss_anim_tree = get_node("AnimationTree");
onready var boss_states = boss_anim_tree["parameters/playback"];
onready var player = $"/root/Main/Player";
onready var pause_timer = $"PauseTimer"



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



#
##wrap the swing functionality
func swing():
	boss_states.travel("Swing");
	swinging = true;
	yield(get_tree().create_timer(.2), "timeout");
	swinging = false;

##makes sure the bear does not lean but looks and moves
func _physics_process(delta):
	var player_loc = player.get("translation");
	look_at(player_loc, Vector3.UP)
	set("rotation.x",0);
	set("rotation.z",0)
	if !swinging && (dist > swing_threshold):
		move_and_collide(dir.normalized() * speed_fac,false);

#
##this timer makes decisions for the bear periodically because on tick is too fast
func _on_Timer_timeout():
	dir = player.get_global_translation () - get_global_translation()
	dir.y = 0;
	speed_fac = rand_range(0.2,0.75) / 4;
	dist = abs(dir.length());
	if !swinging && (abs(dist) <= swing_threshold):	
		swing();




func _on_Area_body_entered(body):
	if body.name == "Player" && swinging:
		player.take_damage(damage);

func take_damage()->void:
	health -= health_dec;
	if health <= 0:
		queue_free();
