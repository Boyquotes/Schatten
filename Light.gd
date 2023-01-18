extends OmniLight


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	if Input.is_action_pressed("light"):
		var position = get_viewport().get_mouse_position()
		# if ev is InputEventMouseButton and ev.pressed and ev.button_index == 1:
		var camera = get_node("../CameraPivot/Camera")
		var from = camera.project_ray_origin(position)
		
		var result = camera.project_position(position, from.y)
		
		var light = get_node(".")
		result.y = light.get_global_translation().y
		var computed_translation = result - light.get_global_translation()
		light.translate(computed_translation)
			# var player = get_node("../../Player")
			# var target = result.position
			# target.y = player.get_global_translation().y
			# player.look_at(target, Vector3.UP)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
