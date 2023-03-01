extends KinematicBody

onready var boss_anim_tree = get_node("AnimationTree");
onready var boss_states = boss_anim_tree["parameters/playback"];
onready var player = $"/root/Main/Player";

export var speed = 1;
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	print(boss_anim_tree)
	print(boss_states)
	print(player, "help me");
	swing();


func swing():
	boss_states.travel("Swing");

func _physics_process(delta):
	var player_loc = player.get("translation");
	look_at(player_loc, Vector3.UP)
	move_and_collide(Vector3(-.01,0,0),false)

