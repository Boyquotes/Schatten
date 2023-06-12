extends Camera


export var NOISE_SHAKE_SPEED: float = 70.0

export var NOISE_SHAKE_STRENGTH: float = 0.40

export var SHAKE_DECAY:float = 15.0

onready var rand =  RandomNumberGenerator.new()
onready var noise = OpenSimplexNoise.new()

var noise_i: float = 0.0
var shake_strength: float = 0.0
	
func _ready() -> void:
	rand.randomize()
	noise.seed = rand.randi()
	noise.period = 2

func apply_noise_shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH
	
func _physics_process(_delta):
	var position = get_viewport().get_mouse_position()
	# if ev is InputEventMouseButton and ev.pressed and ev.button_index == 1:
	
	# The code below first moves the initial point of the ray in the 2D plane to the mouse position
	# and then casts the ray straight down. This is accurate for a camera in the
	# orthogonal projection, but not correct for a camera in the perspective projection.
	# But for the purposes of this code, this detail doesn't matter.
	# (Since we are only concerned with the direction.)
	
	var camera = get_node(".")
	var from = camera.project_ray_origin(position)
	var to = from + camera.project_ray_normal(position) * 200
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to)
	if result:
		var player = get_node("../../Player")
		var target = result.position
		target.y = player.get_global_translation().y
		player.look_at(target, Vector3.UP)
		
	shake_strength = lerp(shake_strength,0,SHAKE_DECAY * _delta)
	var off:Vector2 = get_noise_offset(_delta)
	h_offset = off[0]
	v_offset = off[1]
	
	
func get_noise_offset(delta:float) ->Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	return Vector2(noise.get_noise_2d(1,noise_i) * shake_strength,noise.get_noise_2d(100,noise_i) * shake_strength )
	


