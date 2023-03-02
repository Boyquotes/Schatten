extends KinematicBody

onready var boss_anim_tree = get_node("AnimationTree");
onready var boss_states = boss_anim_tree["parameters/playback"];
onready var player = $"/root/Main/Player";
onready var pause_timer = $"PauseTimer"

export var speed = 1;
var dir = Vector3(1,0,1);
var swinging = false;
var swing_threshold = 3.0;

#speed fac will makes the speed manageable
export var speed_fac = 0.25;
var dist = 20;

export var damage = 15

# Called when the node enters the scene tree for the first time.
func _ready():
	print(boss_anim_tree)
	print(boss_states)
	print(player, "help me");

#wrap the swing functionality
func swing():
	boss_states.travel("Swing");

#makes sure the bear does not lean but looks and moves
func _physics_process(delta):
	var player_loc = player.get("translation");
	look_at(player_loc, Vector3.UP)
	set("rotation.x",0);
	set("rotation.z",0)
	if !swinging:
		move_and_collide(dir.normalized() * speed_fac,false);


#this timer makes decisions for the bear periodically because on tick is too fast
func _on_Timer_timeout():
	if dist > swing_threshold:
		dir = player.get("translation") - get("translation")
		dir.y = 0;
		speed_fac = rand_range(0.2,0.75) / 4;
	dist = (player.get("translation") - get("translation")).length();
	if (dist < swing_threshold): 
		dir = Vector3.ZERO;
		speed_fac = 0
		if  !swinging:	
				pause_timer.start()
				swinging = true;
				swing();

#travels to the walk cycle
func _on_AnimationPlayer_animation_finished(anim_name):
	boss_states.travel("BearLoop")

#pauses after swinging slightly
func _on_PauseTimer_timeout():
	swinging = false

func _on_Area_body_entered(body:Node):
	if body.name == "Player" && swinging:
		player.take_damage(damage)
