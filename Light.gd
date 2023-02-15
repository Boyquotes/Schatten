extends OmniLight

var move_to = null

onready var Hand = $"../Player/Pivot/KidActions/Armature/Skeleton/LeftHand/Spatial";
onready var RHand = $"../Player/Pivot/KidActions/Armature/Skeleton/BoneAttachment";
onready var SwingTimer = $"BearFinal/Timer"
var Other = null;
var to_hand:bool = true;
var waiting:bool = false;
onready var light = $".";
var Speed = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	print(RHand)
	SwingTimer.connect("timeout",self,"timeout");


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
		
		#var computed_translation = result - light.get_global_translation()
		#light.translate(computed_translation)
	if (move_to != null):
		light.global_translation = light.get_global_translation().move_toward(move_to, Speed * _delta)

func timeout():
	waiting = false;
	SwingTimer.stop();
	var position = get_viewport().get_mouse_position()
	# if ev is InputEventMouseButton and ev.pressed and ev.button_index == 1:
	var camera = get_node("../CameraPivot/Camera")
	var from = camera.project_ray_origin(position)

	var result = camera.project_position(position, from.y)

	result.y = light.get_global_translation().y
	move_to = result
	Speed = 40;
	
