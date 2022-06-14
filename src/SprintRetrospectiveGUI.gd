extends Control

func _ready():
	$"Button".connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	
	for userstory_node in $"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI/ScrollContainer/VBoxContainer".get_children():
		userstory_node.get_node("Button").pressed = false
	$"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".total_userstories_chosen = 0
	$"/root/Main".chosen_userstories = []
	
	var completed_userstories = []
	
	for userstory in $"/root/Main".userstories:
		var tasks_completed = 0
		for task in userstory.tasks_list:
			if (task.completionPercentage >= 100):
				tasks_completed += 1
		if (tasks_completed >= userstory.tasks_list.size()):
			completed_userstories.append(userstory)
	
	print("TOTAL COMPLETED USERSTORIES: ", completed_userstories.size())
	print("TOTAL USERSTORIES: ", $"/root/Main".userstories.size())
	
	if (completed_userstories.size() >= $"/root/Main".userstories.size()):
		$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/".visible = false
		var locale = TranslationServer.get_locale()
		if (locale.substr(0, 2) == "en"):
			$"/root/Main/CongratulationsScreen/VBoxContainer/CongratulationsRichTextLabel_en".visible = true
			$"/root/Main/CongratulationsScreen/VBoxContainer/CongratulationsRichTextLabel_ru".visible = false
		elif (locale.substr(0, 2) == "ru"):
			$"/root/Main/CongratulationsScreen/VBoxContainer/CongratulationsRichTextLabel_en".visible = false
			$"/root/Main/CongratulationsScreen/VBoxContainer/CongratulationsRichTextLabel_ru".visible = true
		$"/root/Main/CongratulationsScreen".visible = true
	else:
		$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".visible = true
		$"/root/Main".set_available_userstories()
