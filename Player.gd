extends KinematicBody

# How fast the player moves in meters per second.
export var speed = 14
export var dash = 25
# The downward acceleration when in the air, in meters per second squared.
export var fall_acceleration = 75

signal health_changed

var health = 100

var velocity = Vector3.ZERO

onready var player_animator = get_node("Pivot/KidActions/AnimationPlayer");
onready var player_anim_tree = get_node("Pivot/KidActions/AnimationTree");
onready var player_states = player_anim_tree["parameters/playback"];
onready var mat = $"Pivot/KidActions/Armature/Skeleton/Band_low".get("material/0")
onready var DmgTween = $"DamageTween";

onready var light = $"../OmniLight";

onready var dash_timer = $"DashTimer";
var is_dashing:bool = false;
var can_damage:bool = true;
var last_dash_time = null;

onready var particles = $"CPUParticles";
onready var particles2 = $"CPUParticles2";

onready var UI = $"../CanvasLayer/HealthBar"

func _ready():
	player_animator.get_animation("Idle").set_loop(true);
	print(mat)
	mat.set("shader_param/transparency",1.0);
	mat.set("shader_param/tint", 1.0);
	player_animator.set_speed_scale(100);
	print(UI)

func _physics_process(delta):
	movePlayer(delta);
	
func movePlayer(delta):
	# We create a local variable to store the input direction.
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly.
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		# Notice how we are working with the vector's x and z axes.
		# In 3D, the XZ plane is the ground plane.
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	
	if Input.is_action_pressed("attack"):
		player_states.travel("SwordSwing");
	
	if Input.is_action_just_pressed("light"):
		UI.toggle_light();	
	
	if Input.is_action_just_pressed("light") && !light.to_hand:
		player_states.travel("Throw");

	if Input.is_action_just_pressed("dash") and !is_dashing and velocity.length() != 0 and (last_dash_time == null or OS.get_unix_time() - last_dash_time > 2 ):
		speed = dash;
		can_damage = false;
		dash_timer.start();
		is_dashing = true
		player_states.travel("Dash");
		player_animator.set("speed",4);
		particles.set("emitting", true);
		particles2.set("emitting", true);
		last_dash_time = OS.get_unix_time();
	
	# Get distance from player to height
	var distanceToLight = light.get_global_translation().distance_to(get_global_translation())
	if !light.to_hand || distanceToLight > 8:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		velocity.y -= fall_acceleration * delta
		velocity = move_and_slide(velocity, Vector3.UP)
	else:
		velocity = Vector3(0,0,0);
		#TODO: There is an error here where it does not correctly travel from walk to idle
		if player_states.get_current_node() == "Walk":
			player_states.travel("Idle");

#
func _process(delta):
	if velocity.length() >= 1:
		player_states.travel("Walk");
	else:
		player_states.travel("Idle");


func _on_DashTimer_timeout():
	speed = 14;
	can_damage = true;
	particles.set("emitting", false);
	particles2.set("emitting", false);
	is_dashing = false;


func _on_Area_body_entered(body):
	if body.damage && can_damage:
		take_damage(body.damage)
		body.queue_free()


func take_damage(damage:float):
		mat.set("shader_param/tint", 3.0);
		DmgTween.interpolate_property(mat,"shader_param/transparency",1.0,0.0,.5,Tween.TRANS_BOUNCE,Tween.EASE_OUT);
		DmgTween.start();
		health -= damage
		#health = 0
		if (health <= 0):
			health = 0
			emit_signal("health_changed", 0)
			print("you ded")
			$"/root/Main/CanvasLayer/DeathPopup"._deathPopup()
		else:
			emit_signal("health_changed", health)


func _on_DamageTween_tween_completed(object, key):
	mat.set("shader_param/tint", 1.0);
	mat.set("shader_param/transparency",1.00);
