extends Control

func _ready():
	$"Button".connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	
	for userstoryNode in get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI/ScrollContainer/VBoxContainer").get_children():
		userstoryNode.get_node("Button").pressed = false
	get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").total_userstories_chosen = 0
	get_node("/root/Main").chosenUserStories = []
	
	var completedUserStories = []
	
	for userstory in get_node("/root/Main").userstories:
		var tasks_completed = 0
		for task in userstory.tasksList:
			if (task.completionPercentage >= 100):
				tasks_completed += 1
		if (tasks_completed >= userstory.tasksList.size()):
			completedUserStories.append(userstory)
	
	print("TOTAL COMPLETED USERSTORIES: ", completedUserStories.size())
	print("TOTAL USERSTORIES: ", get_node("/root/Main").userstories.size())
	
	if (completedUserStories.size() >= get_node("/root/Main").userstories.size()):
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/").visible = false
		get_node("/root/Main/CongratulationsScreen").visible = true
	else:
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI").visible = true
		get_node("/root/Main").setAvailableUserStories()
