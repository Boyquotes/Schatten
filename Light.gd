extends OmniLight

var move_to = null

onready var Hand = $"../Player/Pivot/KidActions/Armature/Skeleton/LeftHand/Spatial";
onready var SwingTimer = $"BearFinal/Timer"
var Other = null;
var to_hand:bool = true;
var waiting:bool = false;
onready var light = $".";
var Speed = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	print(SwingTimer)
	SwingTimer.connect("timeout",self,"timeout");
	pass # Replace with function body.

func _physics_process(_delta):
	
	if Input.is_action_just_pressed("light"):
		to_hand = !to_hand
		
		if !to_hand:
			waiting = true;
			SwingTimer.start();
		else:
			Speed = 45;
			
	if to_hand or waiting:
		move_to = Hand.get_global_translation() + Vector3(-1,4,0);
		
		# var computed_translation = result - light.get_global_translation()
		# light.translate(computed_translation)
	if (move_to != null):
		light.global_translation = light.get_global_translation().move_toward(move_to, Speed * _delta)

func timeout():
	waiting = false;
	print("Hamed");
	SwingTimer.stop();
	var position = get_viewport().get_mouse_position()
	# if ev is InputEventMouseButton and ev.pressed and ev.button_index == 1:
	var camera = get_node("../CameraPivot/Camera")
	var from = camera.project_ray_origin(position)

	var result = camera.project_position(position, from.y)

	result.y = light.get_global_translation().y
	move_to = result
	Speed = 20;
	
