extends VBoxContainer

func _ready():
	$"CloseButton".connect("pressed", self, "_on_CloseButton_pressed")
	$"CenterContainer/VBoxContainer/MusicButton".connect("pressed", self, "_on_MusicButton_pressed")
	$"CenterContainer/VBoxContainer/VBoxContainer/LanguageOptionButton".connect("item_selected", self, "_on_LanguageOptionButton_item_selected")

func _on_CloseButton_pressed():
	self.visible = false
	$"/root/Main/TitleScreen".visible = true

func _on_MusicButton_pressed():
	if ($"/root/Main".music_is_playing):
		$"/root/Main".music_is_playing = false
		$"/root/Main/Music".stop()
	else:
		$"/root/Main".music_is_playing = true
		$"/root/Main/Music".play()

func _on_LanguageOptionButton_item_selected(index):	
	if (index == 0):
		TranslationServer.set_locale("en")
	elif (index == 1):
		TranslationServer.set_locale("ru")
