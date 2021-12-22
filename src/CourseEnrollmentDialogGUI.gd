extends PopupDialog

func _ready():
	$"Button2".connect("pressed", self, "_on_Button2_pressed")

func _on_Button2_pressed():
	self.visible = false
