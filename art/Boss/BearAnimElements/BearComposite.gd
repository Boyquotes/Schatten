extends KinematicBody

onready var boss_anim_tree = get_node("AnimationTree");
onready var boss_states = boss_anim_tree["parameters/playback"];
onready var player = $"/root/Main/Player";

export var speed = 1;
var t = 0
var dir = Vector3(1,0,1);
var swinging = false;
var swing_threshold = 3.0;
export var speed_fac = 0.25;
var dist = Vector3(10,10,0);

# Called when the node enters the scene tree for the first time.
func _ready():
	print(boss_anim_tree)
	print(boss_states)
	print(player, "help me");


func swing():
	boss_states.travel("Swing");

func _physics_process(delta):
	var player_loc = player.get("translation");
	look_at(player_loc, Vector3.UP)
	dist = (player.get("translation") - get("translation")).length();
	if (dist < swing_threshold): 
		dir = Vector3.ZERO;
		if  !swinging:	
				swinging = true;
				print("swingstart")
				swing();
	else:
		move_and_collide(dir.normalized() * speed_fac,false)



func _on_Timer_timeout():
	if dist > swing_threshold:
		dir = player.get("translation") - get("translation")
		dir.y = 0;


func _on_AnimationPlayer_animation_finished(anim_name):
	boss_states.travel("BearLoop")
	if anim_name.lowercase() == "swing":
		print("swing end")
		swinging = false;

