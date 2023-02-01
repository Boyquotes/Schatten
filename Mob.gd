extends KinematicBody
onready var player := get_node("/root/Main/Player")

# Minimum speed of the mob in meters per second.
export var min_speed = 8
# Maximum speed of the mob in meters per second.
export var max_speed = 15

var damage = 10

var velocity = Vector3.ZERO

func _physics_process(_delta):
	
	#var dir = (player.global_transform.origin - self.global_transform.origin).normalized()
	#move_and_slide(dir*velocity*1.5)
	look_at(player.global_transform.origin, Vector3.UP)
	var dir = (player.global_transform.origin - self.global_transform.origin).normalized()
	move_and_collide(dir * velocity * _delta)

func initialize(start_position, player_position):
	look_at_from_position(start_position, player_position, Vector3.UP)

	var random_speed = rand_range(min_speed, max_speed)
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _on_VisibilityNotifier_screen_exited():
	queue_free()
	
func take_damage():
	print("I took damage!");
	queue_free()
