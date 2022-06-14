extends VBoxContainer

var total_userstories_chosen = 0

func _ready():
	$"Panel/Button".connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	if (!$"/root/Main".game_is_started):
		$"/root/Main".game_is_started = true
		$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Label".text = tr("TOPGUI_SPRINT") + " 1, " + tr("TOPGUI_DAY") + " 1/7"
		$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer"._update_daily_scene(1)
	$"/root/Main".set_available_tasks()
	$"/root/Main/ColorRect/VBoxContainer2/MetricsScene/VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/".set_values_for_start_of_new_sprint()
	$"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Label".visible = true
	$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Button".visible = true
	$"/root/Main/ColorRect/VBoxContainer2/DailyGUI".visible = true
	$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/MetricsButton".disabled = false
	$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/DevelopersButton".disabled = false
	$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/DailyButton".disabled = false
	$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/TasksButton".disabled = false
