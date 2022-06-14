extends CenterContainer

func _ready():
	$"VBoxContainer/Button".connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	$"/root/Main/CongratulationsScreen".visible = false
	$"/root/Main/TitleScreen".visible = true
	$"/root/Main/".game_is_started = false
