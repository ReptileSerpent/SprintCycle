extends Control
var Task = preload("res://src/Task.gd")
var Developer = preload("res://src/Developer.gd")
var UserStory = preload("res://src/UserStory.gd")

var music_is_playing = true
var game_is_started = false
var developers = []
var userstories = []
var previous_daily = ""			# move somewhere else

func _ready():
	$Music.play()

var chosen_userstories = []

func set_available_userstories():
	chosen_userstories = []
	for node in $"ColorRect/VBoxContainer2/UserStoriesGUI/ScrollContainer/VBoxContainer".get_children():
		node.queue_free()
	var completed_userstories = []
	
	for userstory in userstories:
		var tasks_completed = 0
		for task in userstory.tasks_list:
			if (task.completionPercentage >= 100):
				tasks_completed += 1
		if (tasks_completed >= userstory.tasks_list.size()):
			completed_userstories.append(userstory)
	
	for userstory in userstories:
		if (userstory in completed_userstories):
			continue
		
		var total_completed_userstories_in_parent_user_stories = 0
		for parent_userstory in userstory.parent_user_stories:
			if (parent_userstory in completed_userstories):
				total_completed_userstories_in_parent_user_stories += 1
		if (total_completed_userstories_in_parent_user_stories >= userstory.parent_user_stories.size()):
			var userstory_scene = load("src/UserStoryScene.tscn").instance()
			userstory_scene.userstory_class_instance = userstory
			userstory_scene.get_node("NameLabel").text = userstory.name
			userstory_scene.get_node("DescriptionLabel").text = userstory.description
			userstory_scene.get_node("PointsLabel").text = tr("USERSTORY_POINTS") + " " + str(userstory.points)
			$"ColorRect/VBoxContainer2/UserStoriesGUI/ScrollContainer/VBoxContainer".add_child(userstory_scene)

func set_available_tasks():
	for node in $"/root/Main/ColorRect/VBoxContainer2/TasksGUI/VBoxContainer".get_children():
		node.queue_free()
	
	for userstory in chosen_userstories:
		print(userstory.name)
		for task in userstory.tasks_list:
			var task_node = load("src/TaskScene.tscn").instance()
			task_node.task_class_instance = task
			task_node.get_node("VBoxContainer/Control/TaskDescriptionLabel").text = task.name
			task_node.get_node("VBoxContainer/Control/UserStoryNameLabel").text = "(" + userstory.name + ")"
			task_node.get_node("VBoxContainer/Control/HoursInitialEstimationLabel").text = tr("TASK_INITIALESTIMATION") + " " + str(task.total_hours_initial_estimation) + " "
			if (task.total_hours_initial_estimation == 1):
				task_node.get_node("VBoxContainer/Control/HoursInitialEstimationLabel").text += tr("TASK_HOUR")
			else:
				task_node.get_node("VBoxContainer/Control/HoursInitialEstimationLabel").text += tr("TASK_HOURS")
			for developer in $"/root/Main/".developers:
				task_node.get_node("VBoxContainer/Control/DeveloperOptionButton").add_item(developer.name)
				task_node.get_node("VBoxContainer/Control/TemporaryHelpOptionButton").add_item(developer.name)
			
			task_node.get_node("VBoxContainer/Control/CompletionPercentageLabel").text = str(task.completionPercentage) + tr("TASK_PERCENTCOMPLETE")
			$"/root/Main/ColorRect/VBoxContainer2/TasksGUI/VBoxContainer".add_child(task_node)
