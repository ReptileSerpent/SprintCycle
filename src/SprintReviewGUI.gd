extends VBoxContainer

func _ready():
	$"Panel/ProceedToSprintRetrospectiveButton".connect("pressed", self, "_on_ProceedToSprintRetrospectiveButton_pressed")

func _on_ProceedToSprintRetrospectiveButton_pressed():
	$"/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI".visible = false
	
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/CompletedAllTasksLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/GoodCooperationLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/PoorCooperationLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/LowMoraleLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/BoredomLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/TooManyTasksLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/RemoveDailiesLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/AddMoreStoriesToSprintsLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/HaveFewerStoriesInSprintsLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/AssignTasksBetterLabel".visible = false
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/NotAllTasksCompletedLabel".visible = false
	
	var userstories_completed = 0
	for userstory in $"/root/Main".chosen_userstories:
		var tasks_completed = 0
		for task in userstory.tasks_list:
			if (task.completionPercentage >= 100):
				tasks_completed += 1
		if (tasks_completed == userstory.tasks_list.size()):
			userstories_completed += 1
	
	if (userstories_completed == $"/root/Main".chosen_userstories.size()):
		$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/CompletedAllTasksLabel".visible = true
	else:
		$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/NotAllTasksCompletedLabel".visible = true
		$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/AssignTasksBetterLabel".visible = true
	
	if (tr("DAILYGUI_NOTHINGWORKEDONASNWER") in $"/root/Main".previous_daily):
		$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/BoredomLabel".visible = true
		$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI/AddMoreStoriesToSprintsLabel".visible = true
	
	$"/root/Main/ColorRect/VBoxContainer2/SprintRetrospectiveGUI".visible = true
