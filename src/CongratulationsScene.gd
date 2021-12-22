extends Control

func _ready():
	$"Button".connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	get_node("/root/Main/CongratulationsScreen").visible = false
	get_node("/root/Main/TitleScreen").visible = true
	get_node("/root/Main/").game_is_started = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
