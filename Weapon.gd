extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lightsource
var swordPivot
var swordTip
var player
var space_state

var immediate_geometry

var enemiesHit = []
enum State {STATE_IDLE, STATE_SWINGING}

var state = State.STATE_IDLE
var areaColl
var area
var swing_duration = 1
var timer

func _ready():
	lightsource = $"../../../../../../../../OmniLight"
	player = $"../../../../../../../../Player"
	swordPivot = $"./SwordBase"
	swordTip = $"./SwordTip"
	space_state = get_world().direct_space_state
	state = State.STATE_IDLE
	areaColl = $"Area/Area@CollisionShape"
	area = $"Area"
	timer = Timer.new()
	add_child(timer)
	
	# debugging
	immediate_geometry = ImmediateGeometry.new()
	get_tree().get_root().call_deferred("add_child", immediate_geometry)

func _process(delta):
	if Input.is_action_pressed("attack") && state == State.STATE_IDLE:
		# when first starting to attack, empty hit array
		enemiesHit = []
		state = State.STATE_SWINGING	
		
		#start timer to change state back to idle
		timer.connect("timeout",self,"_on_swing_end")
		timer.wait_time = swing_duration
		timer.one_shot = true
		timer.start()
		
func _physics_process(delta):
	detect_enemy()

#
# get the light source position and get sword pivot/tip position
# draw a line from light source position to sword pivot and tip position
# where this point intersects the ground draw a line between the tip and pivot
# during each swing, keep track of the enemies hit by the ray in enemiesHit,
# if not already hit, deal damage to them.
func detect_enemy():
	# cast ray from pivot to ground
	var pivot_to = swordPivot.get_global_translation() + (swordPivot.get_global_translation() - lightsource.get_global_translation()).normalized() * 50
	var pivot_ray = space_state.intersect_ray(lightsource.get_global_translation(), pivot_to,[player])
	assert(pivot_ray != null) #make sure it hit the ground
	#get position for where the ray hits the ground
	var pivot_shadow_pos = pivot_ray.position 
	
	
	# cast ray from swordTip to ground
	var tip_to = swordTip.get_global_translation() + (swordTip.get_global_translation() - lightsource.get_global_translation()).normalized() * 50
	var tip_ray = space_state.intersect_ray(lightsource.get_global_translation(), tip_to,[player])
	assert(tip_ray != null)
	var tip_shadow_pos = tip_ray.position
	
	# connect the two points of intersection on the ground as a line,
	# then do a raycast between the line during the swing animation
	
	set_sword_area_position(pivot_shadow_pos,tip_shadow_pos)
	
	#debug lines
	#var zOffset = Vector3(0,0,0)
	#line(pivot_shadow_pos+zOffset,tip_shadow_pos+zOffset,Color.purple)
	
	
func line(pos1: Vector3, pos2: Vector3, color = Color.white):
	immediate_geometry.clear()
	immediate_geometry.begin(Mesh.PRIMITIVE_LINES)
	immediate_geometry.set_color(color)
	immediate_geometry.add_vertex(pos1)
	immediate_geometry.set_color(color)
	immediate_geometry.add_vertex(pos2)
	immediate_geometry.end()	

func set_sword_area_position(pivot,tip):
	#translate to position of the shadow
	# make the length of the sword as long as the shadow, as wide as the shadow
	area.set_global_translation((pivot+tip)/2)
	areaColl.shape.extents.y = ((pivot.y - tip.y)/2)

	line(area.get_global_translation(),area.get_global_translation()+ Vector3(0,areaColl.shape.extents.y,0))
	
func _on_Area_body_entered(body):
	if body.name.find("Mob") >= 0 && state == State.STATE_SWINGING && !enemiesHit.has(body.name):
		body.take_damage()
		enemiesHit.append(body.name)


func _on_swing_end():
	enemiesHit = []
	state = State.STATE_IDLE
