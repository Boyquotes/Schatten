extends OmniLight

var move_to = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	var light = get_node(".")
	if Input.is_action_pressed("light"):
		var position = get_viewport().get_mouse_position()
		# if ev is InputEventMouseButton and ev.pressed and ev.button_index == 1:
		var camera = get_node("../CameraPivot/Camera")
		var from = camera.project_ray_origin(position)
		
		var result = camera.project_position(position, from.y)
		
		result.y = light.get_global_translation().y
		move_to = result
		# var computed_translation = result - light.get_global_translation()
		# light.translate(computed_translation)
	if (move_to != null):
		light.global_translation = light.get_global_translation().move_toward(move_to, 10 * _delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
