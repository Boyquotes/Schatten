extends Node

export(PackedScene) var mob_scene

onready var to_spawn:bool = true
onready var endpoint = preload("res://LevelEnd.tscn").instance()

var mob_count = 1;

func _ready():
	randomize()

func _on_MobTimer_timeout():
	if to_spawn:
		var mob = mob_scene.instance()

		var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
		mob_spawn_location.unit_offset = randf()
		var player_position = $Player.transform.origin
		mob.initialize(mob_spawn_location.translation, player_position)

		add_child(mob)
	elif mob_count == 1 && !to_spawn:
		end()

func dec_count():
	mob_count -= 1;
	if mob_count == 1 && !to_spawn:
		#END GAME SEQUENCE
		end()

func end():
	add_child(endpoint)
	endpoint.set("translation",Vector3(30.5,-1.3,0))
	endpoint.rotate_door();
	
