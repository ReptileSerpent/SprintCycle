extends VBoxContainer

func _ready():
	$"CloseButton".connect("pressed", self, "_on_CloseButton_pressed")

func _on_CloseButton_pressed():
	self.visible = false
	$"/root/Main/TitleScreen".visible = true
