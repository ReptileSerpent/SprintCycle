extends VBoxContainer

func _ready():
	$"Panel/Button".connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI").visible = false
	
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/CompletedAllTasksLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/GoodCooperationLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/PoorCooperationLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/LowMoraleLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/BoredomLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/TooManyTasksLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/RemoveDailiesLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/AddMoreStoriesToSprintsLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/HaveFewerStoriesInSprintsLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/AssignTasksBetterLabel").visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/NotAllTasksCompletedLabel").visible = false
	
	var userstories_completed = 0
	for userstory in get_node("/root/Main").chosenUserStories:
		var tasks_completed = 0
		for task in userstory.tasksList:
			if (task.completionPercentage >= 100):
				tasks_completed += 1
		if (tasks_completed == userstory.tasksList.size()):
			userstories_completed += 1
	
	if (userstories_completed == get_node("/root/Main").chosenUserStories.size()):
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/CompletedAllTasksLabel").visible = true
	else:
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/NotAllTasksCompletedLabel").visible = true
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/AssignTasksBetterLabel").visible = true
	
	if ("no tasks were assigned" in get_node("/root/Main").previous_daily):
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/BoredomLabel").visible = true
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/AddMoreStoriesToSprintsLabel").visible = true
	
	get_node("/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI").visible = true
