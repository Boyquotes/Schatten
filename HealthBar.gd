extends ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = get_node("/root/Main/Player")
	player.connect("health_changed", self, "_on_Player_health_changed")

func _on_Player_health_changed(health):
	print(health)
	set("value", health)
