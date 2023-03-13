extends Node

onready var placeholder = $"Placeholder";

	
func flip()->void:
	set("translation",Vector3(9,-1.5,-11))
	$"AnimationPlayer".play("Bear_flip");
	print("My parent is ",get_parent());
