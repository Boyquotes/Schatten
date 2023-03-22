extends Node

export(PackedScene) var mob_scene

onready var to_spawn:bool = true

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
