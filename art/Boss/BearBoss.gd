extends Spatial

var upperarm_angle = Vector3()
var lowerarm_angle = Vector3()
onready var skel = $"RootNode/QuickRigCharacter_Reference/Skeleton"

onready var bone1 =  skel.find_bone("QuickRigCharacter_RightUpLeg");
onready var bone2 = skel.find_bone("QuickRigCharacter_LeftForeArm");

var time = 0;

func _process(delta):
	
	var pose = skel.get_bone_pose(bone1);
	var newpose = pose.rotated(Vector3(0.0,1.0,0.0),-0.005);
	skel.set_bone_pose(bone1,newpose);
	var pose2 = skel.get_bone_pose(bone2);
	var newpose2 = pose2.rotated(Vector3(0.0,1.0,0.0),sin(time)/50);
	skel.set_bone_pose(bone2,newpose2);
	time += .1
