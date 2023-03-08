extends Node

func _ready():
	set("translation",Vector3(9,-1.5,-11))
	$"AnimationPlayer".play("Bear_flip");
	
