extends Panel

var userstory_class_instance

func _ready():
	$"Button".connect("toggled", self, "_on_Button_toggled")

func _on_Button_toggled(button_pressed):
	if (button_pressed):
		get_node("/root/Main").chosenUserStories.append(userstory_class_instance)
		get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").total_userstories_chosen = get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").total_userstories_chosen + 1
	else:
		get_node("/root/Main").chosenUserStories.erase(userstory_class_instance)
		get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").total_userstories_chosen = get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").total_userstories_chosen - 1
	
	if (get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").total_userstories_chosen > 0):
		get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI/Panel/Button").disabled = false
	else:
		get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI/Panel/Button").disabled = true
	
	print("TOTAL USERSTORIES CHOSEN: ", get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").total_userstories_chosen)
	print("CHOSEN USERSTORIES: ", get_node("/root/Main").chosenUserStories)
