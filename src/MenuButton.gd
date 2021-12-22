extends MenuButton

var popup

func _ready():
	popup = get_popup()
	# popup.add_item("Sprint backlog")
	popup.add_item("Music on/off")
	popup.add_item("Return to title screen")
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(ID):
	var item_text = popup.get_item_text(ID)
	#if (item_text == "Sprint backlog"):
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/UnimplementedScene").visible = true;
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/DailyGUI").visible = false;
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/TasksGUI").visible = false;
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").visible = false;
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI").visible = false;
	if (item_text == "Music on/off"):
		if (get_node("/root/Main").music_is_playing):
			get_node("/root/Main").music_is_playing = false
			get_node("/root/Main/Music").stop()
		else:
			get_node("/root/Main").music_is_playing = true
			get_node("/root/Main/Music").play() 
	elif (item_text == "Return to title screen"):
		get_node("/root/Main/ColorRect/VBoxContainer2").visible = false
		get_node("/root/Main/TitleScreen").visible = true
