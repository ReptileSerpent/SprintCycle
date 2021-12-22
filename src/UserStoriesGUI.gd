extends VBoxContainer

var total_userstories_chosen = 0

func _ready():
	$"Panel/Button".connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Label").visible = true
	get_node("/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Button").visible = true
	get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI").visible = true
	get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/MetricsButton").disabled = false
	get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/DevelopersButton").disabled = false
	get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/DailyButton").disabled = false
	get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/TasksButton").disabled = false
	$"/root/Main".setAvailableTasks()
	if (!get_node("/root/Main").game_is_started):
		$"/root/Main".setAvailableTasks()
		$"/root/Main".game_is_started = true
		get_node("/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer")._update_daily_scene(1)
		get_node("/root/Main/ColorRect/VBoxContainer2/MetricsScene/VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/SprintBurndownNode2D").draw(1, 1)
