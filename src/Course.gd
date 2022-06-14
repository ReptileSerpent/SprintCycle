extends Panel

func _ready():
	$"Button".connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	$"/root/Main/PopupDialog".visible = true
