extends Control

func _ready():
	$"VBoxContainer/VBoxContainer2/StartGameButton".connect("pressed", self, "_on_StartGameButton_pressed")
	$"VBoxContainer/VBoxContainer2/CreditsButton".connect("pressed", self, "_on_CreditsButton_pressed")
	$"VBoxContainer/VBoxContainer2/MusicButton".connect("pressed", self, "_on_MusicButton_pressed")

func _on_StartGameButton_pressed():
	get_node("/root/Main/TitleScreen").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2").visible = true
	
	if (!get_node("/root/Main").game_is_started):
		get_node("/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Label").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Button").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/MetricsScene").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/TasksGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").visible = true
		get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/MetricsButton").disabled = true
		get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/DevelopersButton").disabled = true
		get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/DailyButton").disabled = true
		get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/TasksButton").disabled = true

func _on_CreditsButton_pressed():
	get_node("/root/Main/TitleScreen").visible = false
	get_node("/root/Main/Credits").visible = true

func _on_MusicButton_pressed():
	if (get_node("/root/Main").music_is_playing):
		get_node("/root/Main").music_is_playing = false
		get_node("/root/Main/Music").stop()
	else:
		get_node("/root/Main").music_is_playing = true
		get_node("/root/Main/Music").play()

func _process(delta):
	$"VBoxContainer/CycleSprite".set_rotation_degrees($"VBoxContainer/CycleSprite".rotation_degrees + 120 * delta)
	if ($"VBoxContainer/CycleSprite".get_rotation_degrees() > 360):
		$"VBoxContainer/CycleSprite".set_rotation_degrees($"VBoxContainer/CycleSprite".rotation_degrees - 360)	# prevents overflow
