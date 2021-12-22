extends HBoxContainer

var sprint = 1
var day = 1
var label_format_string = "Sprint %d, Day %d/7"

func _ready():
	$Button.connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	get_node("Button/ClickSound").play()
	_process_assignments()	
	get_node("/root/Main/ColorRect/VBoxContainer2/MetricsScene").update_metrics_charts(day, sprint)
	day += 1
	if (day > 7):
		day = 1
		sprint += 1
		
		var userstories_completed = 0
		
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI/ScrollContainer/TextLabel").text = ""
		for userstory in get_node("/root/Main").chosenUserStories:
			var tasks_completed = 0
			for task in userstory.tasksList:
				if (task.completionPercentage >= 100):
					tasks_completed += 1
			var completion_percentage = float(tasks_completed) / userstory.tasksList.size()
			print("COMPLETION PERCENTAGE: ", completion_percentage)
			if (completion_percentage > 0.99):
				userstories_completed += 1
			print("USERSTORIES COMPLETED: ", userstories_completed)
			get_node("/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI/ScrollContainer/TextLabel").text += "Userstory \"" + userstory.name + "\"\n"
			get_node("/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI/ScrollContainer/TextLabel").text += "  Completion: " + str(completion_percentage * 100) + "%\n\n"
		
		var stakeholders_reception = "not set"
		if (float(userstories_completed) / get_node("/root/Main").chosenUserStories.size() < 0.7):
			stakeholders_reception = "negative"
			print(float(userstories_completed), " ", get_node("/root/Main").chosenUserStories.size())
		elif (float(userstories_completed) / get_node("/root/Main").chosenUserStories.size() < 0.9):
			stakeholders_reception = "mixed"
		elif (float(userstories_completed) / get_node("/root/Main").chosenUserStories.size() >= 0.9):
			stakeholders_reception = "positive"
			
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI/ScrollContainer/TextLabel").text += "Stakeholders' reception: " + stakeholders_reception
		
		get_node("/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Label").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Button").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/MetricsScene").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/TasksGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/MetricsButton").disabled = true
		get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/DevelopersButton").disabled = true
		get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/DailyButton").disabled = true
		get_node("/root/Main/ColorRect/VBoxContainer2/BottomGUI/TasksButton").disabled = true
		get_node("/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI").visible = true
		
		get_node("/root/Main").previous_daily = get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").text
		_update_daily_scene(day)
		_reset_various_values()
	else:
		get_node("/root/Main/ColorRect/VBoxContainer2/MetricsScene").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI").visible = true
		get_node("/root/Main/ColorRect/VBoxContainer2/TasksGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").visible = false
		get_node("/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI").visible = false
		
		_update_daily_scene(day)
		_reset_various_values()
	$Label.text = label_format_string % [sprint, day]

func _process_assignments():
	for taskNode in get_node("/root/Main/ColorRect/VBoxContainer2/TasksGUI/VBoxContainer").get_children():
		
		# processing temporary task assignments
		for asignee in taskNode.task_class_instance.assigned_temporarily:
			print("ASIGNEE: ", asignee.name)
			var time_the_task_needs = 0
			var time_on_temporary_assignment = 1
			for technology in taskNode.task_class_instance.technologies:
				if (technology[0] in asignee.known_technologies[0]):
					var asignee_known_technology = _find_second_member(technology[0], asignee.known_technologies)
					var multiplier = _get_time_multiplier(technology[1], asignee_known_technology[1])
					if (multiplier > 1):
						asignee.technology_is_unfamiliar = true
					if (multiplier >= 2):
						asignee.technology_is_very_unfamiliar = true
					time_the_task_needs = (taskNode.task_class_instance.total_hours_initial_estimation - (taskNode.task_class_instance.completionPercentage * taskNode.task_class_instance.total_hours_initial_estimation / float(100))) * multiplier
				else:
					time_the_task_needs = (taskNode.task_class_instance.total_hours_initial_estimation - (taskNode.task_class_instance.completionPercentage * taskNode.task_class_instance.total_hours_initial_estimation / float(100))) * 4
					asignee.technology_is_very_unfamiliar = true
			print("TIME NEEDED: ", time_the_task_needs)
			print("TIME LEFT: ", asignee.time_left)
			if (asignee.time_left > 1):
				time_on_temporary_assignment = 1
			else:
				time_on_temporary_assignment = asignee.time_left
			taskNode.task_class_instance.completionPercentage += (100 - taskNode.task_class_instance.completionPercentage) * (float(time_on_temporary_assignment) / time_the_task_needs)
			if (taskNode.task_class_instance.completionPercentage >= 100):	# shouldn't happen here but just in case	# might happen due to float imprecision?
				taskNode.task_class_instance.completionPercentage = 100
			taskNode.get_node("VBoxContainer/Control/CompletionPercentageLabel").text = str(taskNode.task_class_instance.completionPercentage) + "% complete"
			asignee.time_left = 0
			asignee.task_stuck_on = taskNode.task_class_instance
			if (taskNode.task_class_instance.completionPercentage >= 100):
				taskNode.get_node("VBoxContainer/Control/AssignButton").disabled = true
			print("COMPLETION PERCENTAGE: ", taskNode.task_class_instance.completionPercentage)
			print("TECHNOLOGY UNFAMILIAR: ", asignee.technology_is_unfamiliar, " ", asignee.technology_is_very_unfamiliar)
		#				time_the_task_needs = 1
		
		# processing task assignments
		for asignee in taskNode.task_class_instance.assigned:
			print("ASIGNEE: ", asignee.name)
			var time_the_task_needs = 0
			for technology in taskNode.task_class_instance.technologies:
				if (technology[0] in asignee.known_technologies[0]):
					var asignee_known_technology = _find_second_member(technology[0], asignee.known_technologies)
					var multiplier = _get_time_multiplier(technology[1], asignee_known_technology[1])
					if (multiplier > 1):
						asignee.technology_is_unfamiliar = true
					if (multiplier >= 2):
						asignee.technology_is_very_unfamiliar = true
					time_the_task_needs = (taskNode.task_class_instance.total_hours_initial_estimation - (taskNode.task_class_instance.completionPercentage * taskNode.task_class_instance.total_hours_initial_estimation / float(100))) * multiplier
				else:
					time_the_task_needs = (taskNode.task_class_instance.total_hours_initial_estimation - (taskNode.task_class_instance.completionPercentage * taskNode.task_class_instance.total_hours_initial_estimation / float(100))) * 4
					asignee.technology_is_very_unfamiliar = true
			print("TIME NEEDED: ", time_the_task_needs)
			print("TIME LEFT: ", asignee.time_left)
			if (time_the_task_needs > asignee.time_left):
				taskNode.task_class_instance.completionPercentage += (100 - taskNode.task_class_instance.completionPercentage) * (float(asignee.time_left) / time_the_task_needs)
				if (taskNode.task_class_instance.completionPercentage >= 100):	# shouldn't happen here but just in case	# might happen due to float imprecision?
					taskNode.task_class_instance.completionPercentage = 100
				taskNode.get_node("VBoxContainer/Control/CompletionPercentageLabel").text = str(taskNode.task_class_instance.completionPercentage) + "% complete"
				asignee.time_left = 0
				asignee.is_stuck_on_task = true
				asignee.task_stuck_on = taskNode.task_class_instance
			else:
				taskNode.task_class_instance.completionPercentage = 100
				taskNode.get_node("VBoxContainer/Control/CompletionPercentageLabel").text = str(taskNode.task_class_instance.completionPercentage) + "% complete"
				asignee.time_left = asignee.time_left - time_the_task_needs
				asignee.tasks_completed_yesterday.append(taskNode.task_class_instance)
			if (taskNode.task_class_instance.completionPercentage >= 100):
				taskNode.get_node("VBoxContainer/Control/AssignButton").disabled = true
			print("COMPLETION PERCENTAGE: ", taskNode.task_class_instance.completionPercentage)
			print("TECHNOLOGY UNFAMILIAR: ", asignee.technology_is_unfamiliar, " ", asignee.technology_is_very_unfamiliar)
	
	for developerNode in $"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI/VBoxContainer".get_children():
		developerNode.developer_class_instance.time_left = 8	# resetting for next day

func _find_second_member(technology_level, known_technologies):
	for known_technology in known_technologies:
		if (technology_level == known_technology[0]):
			return known_technologies[0]

func _get_time_multiplier(technology_level, asignee_known_technology_level):
	var multiplier = 4
	if (technology_level == 1 and asignee_known_technology_level == 0):
		multiplier = 1.5
	elif (technology_level == 1 and asignee_known_technology_level == 1):
		multiplier = 1
	elif (technology_level == 1 and asignee_known_technology_level == 2):
		multiplier = 0.75
	elif (technology_level == 1 and asignee_known_technology_level == 3):
		multiplier = 0.5
	elif (technology_level == 2 and asignee_known_technology_level == 0):
		multiplier = 2
	elif (technology_level == 2 and asignee_known_technology_level == 1):
		multiplier = 1.25
	elif (technology_level == 2 and asignee_known_technology_level == 2):
		multiplier = 1
	elif (technology_level == 2 and asignee_known_technology_level == 3):
		multiplier = 0.75
	elif (technology_level == 3 and asignee_known_technology_level == 0):
		multiplier = 4
	elif (technology_level == 3 and asignee_known_technology_level == 1):
		multiplier = 2
	elif (technology_level == 3 and asignee_known_technology_level == 2):
		multiplier = 1.25
	elif (technology_level == 3 and asignee_known_technology_level == 3):
		multiplier = 1
	return multiplier

func _update_daily_scene(day):
	get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").set_bbcode("[center][b]Daily[/b][/center]")
	if (day == 1):
		get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("\n\nA daily on the first day of a sprint may be skipped. Nothing to report.")
	else:
		for developer in get_node("/root/Main").developers:
			get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("\n\n[b]" + developer.name + "[/b]:\n")
			get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("[b]What did I do yesterday?[/b]\n")
			if (developer.tasks_completed_yesterday.size() > 0):
				get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("Completed tasks")
				for completed_task in developer.tasks_completed_yesterday:
					get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode(" \"" + completed_task.name + "\"")
				get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode(". ")
			if (developer.is_stuck_on_task):
				get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("Worked on task \"" + developer.task_stuck_on.name + "\".")
			if (developer.tasks_completed_yesterday.size() == 0 and !developer.is_stuck_on_task):
				get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("Nothing (no tasks were assigned).")
			
			get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("\n[b]What am i going to do today?[/b]\n")
			if (developer.is_stuck_on_task):
				get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("Continue working on task \"" + developer.task_stuck_on.name + "\".")
			else:
				get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("I don't know yet.")
			
			get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("\n[b]What are my impediments?[/b]\n")
			if (developer.technology_is_very_unfamiliar):
				get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("A technology I encountered is unfamiliar to me.")
			elif (developer.technology_is_unfamiliar):
				get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("A technology I encountered is somewhat unfamiliar to me.")
			else:
				get_node("/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel").append_bbcode("None currently.")

func _reset_various_values():
	# remove tasks from deverlopers, including previous, succeeded and stuck on
	for developer in get_node("/root/Main").developers:
		developer.tasks_completed_yesterday = []
		developer.task_stuck_on = null
		developer.time_left = 8
		developer.is_stuck_on_task = false
		developer.technology_is_unfamiliar = false
		developer.technology_is_very_unfamiliar = false
	
	for userstory in get_node("/root/Main").userstories:
		for task in userstory.tasksList:
			task.assigned = []
			task.assigned_temporarily = []
	
	# remove pressed buttons
	for developer_node in get_node(@"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI/VBoxContainer").get_children():
		developer_node.get_node("AssignmentButton").pressed = false
		developer_node.get_node("TemporaryAssignmentButton").pressed = false
