extends Panel

var userstory_class_instance

func _ready():
	$"Button".connect("toggled", self, "_on_Button_toggled")

func _on_Button_toggled(button_pressed):
	if (button_pressed):
		$"/root/Main".chosen_userstories.append(userstory_class_instance)
		$"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".total_userstories_chosen = $"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".total_userstories_chosen + 1
	else:
		$"/root/Main".chosen_userstories.erase(userstory_class_instance)
		$"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".total_userstories_chosen = $"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".total_userstories_chosen - 1
	
	if ($"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".total_userstories_chosen > 0):
		$"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI/Panel/Button".disabled = false
	else:
		$"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI/Panel/Button".disabled = true
	
	print("TOTAL USERSTORIES CHOSEN: ", $"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".total_userstories_chosen)
	print("CHOSEN USERSTORIES: ", $"/root/Main".chosen_userstories)
