extends VBoxContainer

func _ready():
	$"CloseButton".connect("pressed", self, "_on_CloseButton_pressed")

func _on_CloseButton_pressed():
	get_node("/root/Main/Credits").visible = false
	get_node("/root/Main/TitleScreen").visible = true
