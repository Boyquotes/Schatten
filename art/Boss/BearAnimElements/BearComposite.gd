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

#func _physics_process(delta):
#	var player_loc = player.get("translation");
#	look_at(player_loc, Vector3.UP)
#	move_and_slide(Vector3(1,0,0),to_local(Vector3.UP),false,4,0.785398,false);
#	print(get("translation"));
	
func _physics_process(delta):
	move_and_slide(Vector3(10,0,10) * 1000);
	if self.get("position.y") != 1.6:
		self.set("position.y",1.6)
