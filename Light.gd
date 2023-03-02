extends OmniLight

var move_to = null

onready var Hand = $"../Player/Pivot/KidActions/Armature/Skeleton/LeftHand/Spatial";
onready var RHand = $"../Player/Pivot/KidActions/Armature/Skeleton/BoneAttachment";
onready var SwingTimer = $"BearFinal/Timer"
onready var Bounds = $"../Bounds".get_children();
var extents = null
export var low_y = 2;
export var high_y = 7;
var Other = null;
var to_hand:bool = true;
var waiting:bool = false;
onready var light = $".";
var Speed = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Bounds)
	SwingTimer.connect("timeout",self,"timeout");
	#min x, max x, min y, max y
	extents = [Bounds[0].get_global_translation().x,Bounds[1].get_global_translation().x,Bounds[2].get_global_translation().z,Bounds[3].get_global_translation().z]
	for i in len(extents):
		extents[i] *= .75
	print(extents)


func _physics_process(_delta):
	
	if Input.is_action_just_pressed("light"):
		to_hand = !to_hand
		
		if !to_hand:
			waiting = true;
			SwingTimer.start();
		else:
			Speed = 45;
			
	if to_hand or waiting:
		var offset = Hand.get_global_translation() - RHand.get_global_translation()
		move_to = Hand.get_global_translation() + (offset.normalized() * 1.0);
		move_to.y = low_y;
		#var computed_translation = result - light.get_global_translation()
		#light.translate(computed_translation)
	if (move_to != null):
		move_to.x = clamp(move_to.x,extents[0],extents[1]);
		move_to.z = clamp(move_to.z,extents[2],extents[3]);
		light.global_translation = light.get_global_translation().move_toward(move_to, Speed * _delta)

func timeout():
	waiting = false;
	SwingTimer.stop();
	var position = get_viewport().get_mouse_position()
	# if ev is InputEventMouseButton and ev.pressed and ev.button_index == 1:
	var camera = get_node("../CameraPivot/Camera")
	var from = camera.project_ray_origin(position)

	var result = camera.project_position(position, from.y)

	result.y = high_y;
	move_to = result
	Speed = 40;
	
