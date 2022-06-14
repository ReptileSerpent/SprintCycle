extends MenuButton

var popup

func _ready():
	popup = get_popup()
	# popup.add_item("Sprint backlog")
	popup.add_item("BOTTOMGUI_MENU_MUSICITEM")
	popup.add_item("BOTTOMGUI_MENU_RETURNTOTITLESCREENITEM")
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(ID):
	var item_text = popup.get_item_text(ID)
	#if (item_text == "Sprint backlog"):
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/UnimplementedScene").visible = true;
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/DailyGUI").visible = false;
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/TasksGUI").visible = false;
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").visible = false;
	#	get_node(@"/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI").visible = false;
	if (item_text == "BOTTOMGUI_MENU_MUSICITEM"):
		if ($"/root/Main".music_is_playing):
			$"/root/Main".music_is_playing = false
			$"/root/Main/Music".stop()
		else:
			$"/root/Main".music_is_playing = true
			$"/root/Main/Music".play() 
	elif (item_text == "BOTTOMGUI_MENU_RETURNTOTITLESCREENITEM"):
		$"/root/Main/ColorRect/VBoxContainer2".visible = false
		$"/root/Main/TitleScreen".visible = true
