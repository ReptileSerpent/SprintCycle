extends HBoxContainer

var sprint = 1
var day = 1

func _ready():
	$Button.connect("pressed", self, "_on_Button_pressed")

func _on_Button_pressed():
	$"Button/ClickSound".play()
	_process_assignments()
	$"/root/Main/ColorRect/VBoxContainer2/MetricsScene".update_metrics_charts(day, sprint)
	day += 1
	if (day > 7):
		day = 1
		sprint += 1
		
		var userstories_completed = 0
		
		$"/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI/ScrollContainer/TextLabel".text = ""
		for userstory in $"/root/Main".chosen_userstories:
			var tasks_completed = 0
			for task in userstory.tasks_list:
				if (task.completionPercentage >= 100):
					tasks_completed += 1
			var completion_percentage = float(tasks_completed) / userstory.tasks_list.size()
			print("COMPLETION PERCENTAGE: ", completion_percentage)
			if (completion_percentage > 0.99):
				userstories_completed += 1
			print("USERSTORIES COMPLETED: ", userstories_completed)
			$"/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI/ScrollContainer/TextLabel".text += userstory.name + "\n"
			$"/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI/ScrollContainer/TextLabel".text += "  " + tr("SPRINTREVIEWGUI_COMPLETIONPERCENTAGE") + " " + str(completion_percentage * 100) + "%\n\n"
		
		var stakeholders_reception = "not set"
		if (float(userstories_completed) / $"/root/Main".chosen_userstories.size() < 0.7):
			stakeholders_reception = tr("SPRINTREVIEWGUI_NEGATIVESTAKEHOLDERSRECEPTION")
			print(float(userstories_completed), " ", $"/root/Main".chosen_userstories.size())
		elif (float(userstories_completed) / $"/root/Main".chosen_userstories.size() < 0.9):
			stakeholders_reception = tr("SPRINTREVIEWGUI_MIXEDSTAKEHOLDERSRECEPTION")
		elif (float(userstories_completed) / $"/root/Main".chosen_userstories.size() >= 0.9):
			stakeholders_reception = tr("SPRINTREVIEWGUI_POSITIVESTAKEHOLDERSRECEPTION")
			
		$"/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI/ScrollContainer/TextLabel".text += tr("SPRINTREVIEWGUI_STAKEHOLDERSRECEPTION") + " " + stakeholders_reception
		
		$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Label".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Button".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/MetricsScene".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/DailyGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/TasksGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/MetricsButton".disabled = true
		$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/DevelopersButton".disabled = true
		$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/DailyButton".disabled = true
		$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/TasksButton".disabled = true
		$"/root/Main/ColorRect/VBoxContainer2/SprintReviewGUI".visible = true
		
		$"/root/Main".previous_daily = $"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".text
		_update_daily_scene(day)
		_reset_various_values()
	else:
		$"/root/Main/ColorRect/VBoxContainer2/MetricsScene".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/DailyGUI".visible = true
		$"/root/Main/ColorRect/VBoxContainer2/TasksGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI".visible = false
		
		_update_daily_scene(day)
		_reset_various_values()
	$Label.text = tr("TOPGUI_SPRINT") + " " + str(sprint) + ", " + tr("TOPGUI_DAY") + " " + str(day) + "/7"

func _process_assignments():
	for task_scene_node in $"/root/Main/ColorRect/VBoxContainer2/TasksGUI/VBoxContainer".get_children():
#		if (day == 7):		# FOR DEBUG
#			task_scene_node.task_class_instance.completionPercentage = 100
#			pass
		
		# processing temporary task assignment
		var asignee = task_scene_node.task_class_instance.assigned_temporarily
		if (asignee != null):
			print("ASIGNEE: ", asignee.name)
			var time_the_task_needs = 0
			var time_on_temporary_assignment = 1
			for technology in task_scene_node.task_class_instance.technologies:
				if (technology[0] in asignee.known_technologies[0]):
					var asignee_known_technology = _find_second_member(technology[0], asignee.known_technologies)
					var multiplier = _get_time_multiplier(technology[1], asignee_known_technology[1])
					if (multiplier > 1):
						asignee.technology_is_unfamiliar = true
					if (multiplier >= 2):
						asignee.technology_is_very_unfamiliar = true
					time_the_task_needs = (task_scene_node.task_class_instance.total_hours_initial_estimation - (task_scene_node.task_class_instance.completionPercentage * task_scene_node.task_class_instance.total_hours_initial_estimation / float(100))) * multiplier
				else:
					time_the_task_needs = (task_scene_node.task_class_instance.total_hours_initial_estimation - (task_scene_node.task_class_instance.completionPercentage * task_scene_node.task_class_instance.total_hours_initial_estimation / float(100))) * 4
					asignee.technology_is_very_unfamiliar = true
			print("TIME NEEDED: ", time_the_task_needs)
			print("TIME LEFT: ", asignee.time_left)
			if (asignee.time_left > 1):
				time_on_temporary_assignment = 1
			else:
				time_on_temporary_assignment = asignee.time_left
			task_scene_node.task_class_instance.completionPercentage += (100 - task_scene_node.task_class_instance.completionPercentage) * (float(time_on_temporary_assignment) / time_the_task_needs)
			if (task_scene_node.task_class_instance.completionPercentage >= 100):	# shouldn't happen here but just in case	# might happen due to float imprecision?
				task_scene_node.task_class_instance.completionPercentage = 100
			task_scene_node.get_node("VBoxContainer/Control/CompletionPercentageLabel").text = str(task_scene_node.task_class_instance.completionPercentage) + tr("TASK_PERCENTCOMPLETE")
			asignee.time_left = 0
			asignee.task_stuck_on = task_scene_node.task_class_instance
			if (task_scene_node.task_class_instance.completionPercentage >= 100):
				task_scene_node.get_node("VBoxContainer/Control/DeveloperOptionButton").disabled = true
				task_scene_node.get_node("VBoxContainer/Control/TemporaryHelpOptionButton").disabled = true
			print("COMPLETION PERCENTAGE: ", task_scene_node.task_class_instance.completionPercentage)
			print("TECHNOLOGY UNFAMILIAR: ", asignee.technology_is_unfamiliar, " ", asignee.technology_is_very_unfamiliar)
		
		# processing task assignment
		asignee = task_scene_node.task_class_instance.assigned
		if (asignee != null):
			print("ASIGNEE: ", asignee.name)
			var time_the_task_needs = 0
			for technology in task_scene_node.task_class_instance.technologies:
				if (technology[0] in asignee.known_technologies[0]):
					var asignee_known_technology = _find_second_member(technology[0], asignee.known_technologies)
					var multiplier = _get_time_multiplier(technology[1], asignee_known_technology[1])
					if (multiplier > 1):
						asignee.technology_is_unfamiliar = true
					if (multiplier >= 2):
						asignee.technology_is_very_unfamiliar = true
					time_the_task_needs = (task_scene_node.task_class_instance.total_hours_initial_estimation - (task_scene_node.task_class_instance.completionPercentage * task_scene_node.task_class_instance.total_hours_initial_estimation / float(100))) * multiplier
				else:
					time_the_task_needs = (task_scene_node.task_class_instance.total_hours_initial_estimation - (task_scene_node.task_class_instance.completionPercentage * task_scene_node.task_class_instance.total_hours_initial_estimation / float(100))) * 4
					asignee.technology_is_very_unfamiliar = true
			print("TIME NEEDED: ", time_the_task_needs)
			print("TIME LEFT: ", asignee.time_left)
			if (time_the_task_needs > asignee.time_left):
				task_scene_node.task_class_instance.completionPercentage += (100 - task_scene_node.task_class_instance.completionPercentage) * (float(asignee.time_left) / time_the_task_needs)
				if (task_scene_node.task_class_instance.completionPercentage >= 100):	# shouldn't happen here but just in case	# might happen due to float imprecision?
					task_scene_node.task_class_instance.completionPercentage = 100
				task_scene_node.get_node("VBoxContainer/Control/CompletionPercentageLabel").text = str(task_scene_node.task_class_instance.completionPercentage) + tr("TASK_PERCENTCOMPLETE")
				asignee.time_left = 0
				asignee.is_stuck_on_task = true
				asignee.task_stuck_on = task_scene_node.task_class_instance
			else:
				task_scene_node.task_class_instance.completionPercentage = 100
				task_scene_node.get_node("VBoxContainer/Control/CompletionPercentageLabel").text = str(task_scene_node.task_class_instance.completionPercentage) + tr("TASK_PERCENTCOMPLETE")
				asignee.time_left = asignee.time_left - time_the_task_needs
				asignee.tasks_completed_yesterday.append(task_scene_node.task_class_instance)
			if (task_scene_node.task_class_instance.completionPercentage >= 100):
				task_scene_node.get_node("VBoxContainer/Control/DeveloperOptionButton").disabled = true
				task_scene_node.get_node("VBoxContainer/Control/TemporaryHelpOptionButton").disabled = true
			print("COMPLETION PERCENTAGE: ", task_scene_node.task_class_instance.completionPercentage)
			print("TECHNOLOGY UNFAMILIAR: ", asignee.technology_is_unfamiliar, " ", asignee.technology_is_very_unfamiliar)
	
	for developer_node in $"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI/VBoxContainer".get_children():
		developer_node.developer_class_instance.time_left = 8	# resetting for next day

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
	$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".set_bbcode("[center][b]" + tr("DAILYGUI_HEADING") + "[/b][/center]")
	if (day == 1):
		$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode("\n\n" + tr("DAILYGUI_FIRSTDAYOFSPRINTDAILY"))
	else:
		for developer in $"/root/Main".developers:
			$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode("\n\n[b]" + developer.name + "[/b]:\n")
			$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode("[b]" + tr("DAILYGUI_YESTERDAYSTASKQUESTION") + "[/b]\n")
			if (developer.tasks_completed_yesterday.size() > 0):
				$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(tr("DAILYGUI_COMPLETEDTASKANSWER"))
				for completed_task in developer.tasks_completed_yesterday:
					$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(" \"" + completed_task.name + "\"")
				$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(". ")
			if (developer.is_stuck_on_task):
				$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(tr("DAILYGUI_WORKEDONTASKANSWER") + " \"" + developer.task_stuck_on.name + "\".")
			if (developer.tasks_completed_yesterday.size() == 0 and !developer.is_stuck_on_task):
				$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(tr("DAILYGUI_NOTHINGWORKEDONASNWER"))
			
			$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode("\n[b]" + tr("DAILYGUI_TODAYSTASKQUESTION") + "[/b]\n")
			if (developer.is_stuck_on_task):
				$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(tr("DAILYGUI_WILLCONTINUEWORKINGONTASKANSWER") + " \"" + developer.task_stuck_on.name + "\".")
			else:
				$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(tr("DAILYGUI_DONTKNOWWHATTASKTODAYANSWER"))
			
			$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode("\n[b]" + tr("DAILYGUI_IMPEDIMENTSQUESTION") + "[/b]\n")
			if (developer.technology_is_very_unfamiliar):
				$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(tr("DAILYGUI_UNFAMILIARTECHNOLOGYANSWER"))
			elif (developer.technology_is_unfamiliar):
				$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(tr("DAILYGUI_SOMEWHATUNFAMILIARTECHNOLOGYANSWER"))
			else:
				$"/root/Main/ColorRect/VBoxContainer2/DailyGUI/RichTextLabel".append_bbcode(tr("DAILYGUI_NOIMPEDIMENTSANSWER"))

func _reset_various_values():
	# remove tasks from developers, including previous, succeeded and stuck on
	for developer in $"/root/Main".developers:
		developer.tasks_completed_yesterday = []
		developer.task_stuck_on = null
		developer.time_left = 8
		developer.is_stuck_on_task = false
		developer.technology_is_unfamiliar = false
		developer.technology_is_very_unfamiliar = false
	
	for userstory in $"/root/Main".userstories:
		for task in userstory.tasks_list:
			task.assigned = null
			task.assigned_temporarily = null
	
	# remove chosen options
	for task_scene_node in $"/root/Main/ColorRect/VBoxContainer2/TasksGUI/VBoxContainer".get_children():
		task_scene_node.get_node("VBoxContainer/Control/DeveloperOptionButton").select(0)
		task_scene_node.get_node("VBoxContainer/Control/TemporaryHelpOptionButton").select(0)
		for i in range(1, 5):
			task_scene_node.get_node("VBoxContainer/Control/DeveloperOptionButton").set_item_disabled(i, false)
			task_scene_node.get_node("VBoxContainer/Control/TemporaryHelpOptionButton").set_item_disabled(i, false)
