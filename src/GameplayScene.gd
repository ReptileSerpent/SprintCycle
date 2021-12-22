extends Control

var music_is_playing = true
var game_is_started = false
var developers = []
var userstories = []
var previous_daily = ""			# move somewhere else

func _ready():
	
	randomize()
	
	var developer_names = ["Elizabeth", "Satoru", "Shigeru", "Olivia", "Fatima", "Mehdi", "Galina",
			"Nur","Vasili", "Andrei", "Alfred", "Dmitry", "James", "Adele", "Yuzuki", "Daria",
			"Omar", "Takumi", "Marzieh", "Anton", "Muhammad", "Nozomi", "Noah", "Kaito", "Karim",
			"Yelena", "Valentina", "Martin", "Izumi", "Makoto", "Ivan", "Hazuki", "Maryam", "Kim",
			"Sarah", "Margaret", "Khalid", "Misato", "Svetlana", "Gordon"]
	
	var names_chosen_indexes = []
	while (names_chosen_indexes.size() < 4):
		var random_number = randi() % 40
		if (not (random_number in names_chosen_indexes)):
			names_chosen_indexes.append(random_number)
	
	var names_chosen = []
	for name_index in names_chosen_indexes:
		names_chosen.append(developer_names[name_index])
	
	developers.append(Developer.new(names_chosen[0], 85, 20,
		[["database management", 3], ["system administration", 3], ["computer security", 2]]))
	developers.append(Developer.new(names_chosen[1], 70, 20,
		[["graphic design", 2], ["web design", 2]]))
	developers.append(Developer.new(names_chosen[2], 80, 40,
		[["database management", 1], ["web design", 1], ["computer security", 2]]))
	developers.append(Developer.new(names_chosen[3], 85, 20,
		[["database management", 1], ["computer security", 2]]))
	
	for developer in developers:
		var developer_scene = load("src/Developer.tscn").instance()
		developer_scene.developer_class_instance = developer
		print(developer_scene.developer_class_instance)
		developer_scene.get_node("NameLabel").text = developer.name
		developer_scene.get_node("QualificationsLabel").text = PoolStringArray(developer.known_technologies).join(" ")
		developer_scene.get_node("MoraleLabel").text = "Morale: " + str(developer.morale)
		developer_scene.get_node("ResigningLabel").text = "resigning in " + str(developer.sprints_before_resigning) + " sprints"
		developer_scene.get_node("TotalTasksLabel").text = "Currently assigned to 0 tasks\n(0 temporarily)"
		$"ColorRect/VBoxContainer2/DevelopersGUI/VBoxContainer".add_child(developer_scene)
	
	userstories.append(userstoryConcept)
	userstories.append(userstoryAuth)
	userstories.append(userstoryAdmin)
	userstories.append(userstoryReviews)
	userstories.append(userstoryDeletion)
	userstories.append(userstoryFrontPage)
	userstories.append(userstoryGraphicDesign)
	userstories.append(userstoryChanges1)
	userstories.append(userstoryChanges2)
	
	setAvailableUserStories()
	
	$Music.play()
	
	# $"PopupDialog".visible = true;

var currentUserStories = []
var chosenUserStories = []

func setAvailableUserStories():
	currentUserStories = []
	chosenUserStories = []
	for node in $"ColorRect/VBoxContainer2/UserStoriesGUI/ScrollContainer/VBoxContainer".get_children():
		node.queue_free()
	var completedUserStories = []
	
	for userstory in userstories:
		var tasks_completed = 0
		for task in userstory.tasksList:
			if (task.completionPercentage >= 100):
				tasks_completed += 1
		if (tasks_completed >= userstory.tasksList.size()):
			completedUserStories.append(userstory)
	
	for userstory in userstories:
		if (userstory in completedUserStories):
			continue
		
		var total_completed_userstories_in_parent_user_stories = 0
		for parent_userstory in userstory.parent_user_stories:
			if (parent_userstory in completedUserStories):
				total_completed_userstories_in_parent_user_stories += 1
		if (total_completed_userstories_in_parent_user_stories >= userstory.parent_user_stories.size()):
			currentUserStories.append(userstory)
			var userstory_scene = load("src/UserStory.tscn").instance()
			userstory_scene.userstory_class_instance = userstory
			userstory_scene.get_node("NameLabel").text = userstory.name
			userstory_scene.get_node("DescriptionLabel").text = userstory.description
			userstory_scene.get_node("PointsLabel").text = "Points: " + str(userstory.points)
			$"ColorRect/VBoxContainer2/UserStoriesGUI/ScrollContainer/VBoxContainer".add_child(userstory_scene)

func setAvailableTasks():
	for node in $"/root/Main/ColorRect/VBoxContainer2/TasksGUI/VBoxContainer".get_children():
		node.queue_free()
	
	for userstory in chosenUserStories:
		print(userstory.name)
		for task in userstory.tasksList:
			var taskNode = load("src/Task.tscn").instance()
			taskNode.task_class_instance = task
			taskNode.get_node("VBoxContainer/Control/TaskDescriptionLabel").text = task.name
			taskNode.get_node("VBoxContainer/Control/UserStoryNameLabel").text = "(" + userstory.name + ")"
			taskNode.get_node("VBoxContainer/Control/HoursInitialEstimationLabel").text = "Initial estimation: " + str(task.total_hours_initial_estimation) + " hours"
			if (task.assigned.size() == 0):
				taskNode.get_node("VBoxContainer/Control/AssignedLabel").text = "Assigned: no one"
			else:
				taskNode.get_node("VBoxContainer/Control/AssignedLabel").text = "Assigned: "
				var i = 0
				while i < task.assigned.size():
					if (i == task.assigned.size() - 1):
						taskNode.get_node("VBoxContainer/Control/AssignedLabel").text += task.assigned[i].name
					else:
						taskNode.get_node("VBoxContainer/Control/AssignedLabel").text += task.assigned[i].name + ", "
					i += 1
			
			taskNode.get_node("VBoxContainer/Control/CompletionPercentageLabel").text = str(task.completionPercentage) + "% complete"
			$"/root/Main/ColorRect/VBoxContainer2/TasksGUI/VBoxContainer".add_child(taskNode)

class UserStory:
	var user_story_id = 0
	var name = "Account cancellation story"
	var description = "I am a customer and I want a 'cancel account' button so I can cancel my account"
	var tasksList = []
	var points = 5
	var parent_user_stories = []
	var is_marked_as_completed_in_velocity_chart = false
	
	func _init(name, description, points, tasksList, parent_user_stories):
		self.name = name
		self.description = description
		self.points = points
		self.tasksList = tasksList
		self.parent_user_stories = parent_user_stories

class Task:
	var task_id = 0
	var name = ""
	var technologies = []
	var total_hours_initial_estimation = 5
	var completionPercentage = 0
	var assigned = []
	var assigned_temporarily = []
	
	func _init(name, total_hours_initial_estimation, technologies):
		self.name = name
		self.technologies = technologies
		self.total_hours_initial_estimation = total_hours_initial_estimation

# class Bug: extends Task
#	var preceding_task

class Developer:
	var name = ""
	var morale = 100
	var known_technologies = [["networking", 2],
								["server architecture", 1]]
	var tasks_completed_yesterday = []
	var task_stuck_on
	func set_morale(value):
		morale = value
		if value > 100:
			morale = 100
		elif value < 0:
			morale = 0
	
	var time_left = 8
	var is_stuck_on_task = false
	var technology_is_unfamiliar = false
	var technology_is_very_unfamiliar = false
	var isIll = false
	var isStudying = false
	var isOnVacation = false
	var isResigning = false
	var illnessDaysRemaining = 0
	var studyingDaysRemaining = 0
	var vacationDaysRemaining = 0
	var sprints_before_resigning = 0
	var technologyBeingStudied = ""
	
	func _init(name, morale, sprints_before_resigning, known_technologies):
		self.name = name
		self.morale = morale
		self.sprints_before_resigning = sprints_before_resigning
		self.known_technologies = known_technologies

# user stories graph
# Concept----------------
#  |                    |
# User auth-----	    Admin--------
#  |           |                    |
# Reviews   Account deletion    Front page
#  |           |                    |
# UI design--  -------------------  |
#  |        |                    |  |
#  |        ------------------|  |  |
# Client changes              More client changes

# oh god

var task01 = Task.new("Spin up SQL databases", 2,
			[["system administration", 1], ["database management", 2]])
var task02 = Task.new("Design SQL databases for products, orders and customers", 4,
			[["database management", 2]])
var task03 = Task.new("Write SQL commands for the orders database", 2,
			[["database management", 1]])
var task04 = Task.new("Write SQL commands for the products database", 2,
			[["database management", 1]])
var task05 = Task.new("Write SQL commands for the customers database", 3,
			[["database management", 1], ["computer security", 2]])
var task06 = Task.new("Create a website with a basic layout", 8,
			[["web design", 2]])
var task07 = Task.new("Add a web UI for searching items", 8,
			[["web design", 2]])
var task08 = Task.new("BUG: Database doesn't support non-english letters", 2,
			[["database management", 2]])
var userstoryConcept = UserStory.new("Website concept story",
	"I am a developer and I want a website concept so I can add further functionality to it",
	8, [task01, task02, task03, task04, task05, task06, task07, task08], [])
	
var task11 = Task.new("Add a user interface for logging in", 3,
			[["web design", 1], ["computer security", 2]])
var task12 = Task.new("Add a user interface for registration", 3,
			[["web design", 1], ["computer security", 2]])
var task13 = Task.new("Add a page for account settings", 5,
			[["web design", 1], ["database management", 1]])
var task14 = Task.new("Add a page for current orders", 5,
			[["web design", 1], ["database management", 1]])
var task15 = Task.new("Current orders page fails to load if an order contains more than 3 items", 5,
			[["web design", 2]])
var userstoryAuth = UserStory.new("User authentication story",
	"I am a customer and I want to be able to authenticate so I can manage my account",
	5, [task11, task12, task13, task14, task15], [userstoryConcept])

var task21 = Task.new("Write SQL commands for administrative actions", 2,
			[["database management", 1]])
var task22 = Task.new("Implement a basic web administrator page", 3,
			[["web design", 1]])
var task23 = Task.new("Add orders management functionality", 6,
			[["web design", 1]])
var task24 = Task.new("Add accounts management functionality", 6,
			[["web design", 1]])
var task25 = Task.new("Add administrator authentication UI", 5,
			[["web design", 1], ["computer security", 1]])
var userstoryAdmin = UserStory.new("Administration story",
	"I am a store administrator and I want a graphical UI for adding, editing and removing products, as well as fulfilling orders",
	5, [task21, task22, task23, task24, task25], [userstoryConcept])

var task31 = Task.new("Database changes to allow customers to use a \"5 star\" ratings system", 5,
			[["database management", 2]])
var task32 = Task.new("UI changes to add a \"5 star\" ratings system", 3,
			[["web design", 2]])
var task33 = Task.new("BUG: the page sometimes freezes when loading reviews", 5,
			[["web design", 3]])
var userstoryReviews = UserStory.new("Reviews story",
	"I am a customer and I want to be able to leave a review so that I can share my opinion about a product",
	3, [task31, task32, task33], [userstoryAuth])

var task41 = Task.new("Write SQL commands for account deletion", 3,
			[["database management", 2]])
var task42 = Task.new("Add web UI for account deletion", 3,
			[["web design", 1]])
var task43 = Task.new("BUG: The account deletion button does nothing on some devices", 2,
			[["web design", 2]])
var task44 = Task.new("BUG: The account deletion confirmation prompt is unreadable on some devices", 3,
			[["web design", 2]])
var userstoryDeletion = UserStory.new("Account deletion story",
	"I am a customer and I want to be able to delete my account so that I don't have to worry about an account I don't need anymore",
	3, [task41, task42, task43, task44], [userstoryAuth])

var task51 = Task.new("Show a selection of discounted items on the front page", 8,
			[["web design", 2]])
var task52 = Task.new("Allow editing the front page from the administrator page", 5,
			[["web design", 1]])
var task53 = Task.new("BUG: The UI breaks if more than 10 items are displayed", 2,
			[["web design", 2]])
var task54 = Task.new("BUG: The first item on the front page never shows the discount", 3,
			[["web design", 3]])
var userstoryFrontPage = UserStory.new("Front page story",
	"I am a store manager and I want to be able to show discounted items on the front page so that I can clear out old stock more quickly",
	8, [task51, task52, task53, task54], [userstoryAdmin])

var task61 = Task.new("Pick fitting fonts for the UI", 1,
			[["graphic design", 1]])
var task62 = Task.new("Pick a colour scheme for the UI", 2,
			[["graphic design", 2]])
var task63 = Task.new("Create a design for the UI", 10,
			[["graphic design", 2]])
var task64 = Task.new("Apply the design to the web pages", 20,
			[["web design", 2]])
var userstoryGraphicDesign = UserStory.new("Graphic design story",
	"I am a store owner and I want a pretty graphical interface for the website so that customers are more interested in shopping around here",
	8, [task61, task62, task63, task64], [userstoryReviews])

var task71 = Task.new("Have the authentication window slide in from the side", 2,
			[["web design", 1]])
var task72 = Task.new("Add \"not a robot\" validation to the authentication window", 3,
			[["web design", 2]])
var task73 = Task.new("Move navigation from the left side to the right side of the page", 3,
			[["web design", 1]])
var task74 = Task.new("Database changes to replace the \"5 star\" ratings system with \"thumbs-up/thumbs-down\"", 5,
			[["database management", 2]])
var task75 = Task.new("UI changes to replace the \"5 star\" ratings system with \"thumbs-up/thumbs-down\"", 6,
			[["web design", 2]])
var task76 = Task.new("Allow hiding the username when submitting a review", 2,
			[["web design", 1], ["database management", 1]])
var task77 = Task.new("BUG: the database crashes on startup after a recent security update", 3,
			[["system administration", 3], ["database management"], 1])
var userstoryChanges1 = UserStory.new("Design changes story",
	"I am your client and I want some changes made to the design",
	8, [task71, task72, task73, task74, task75, task76, task77], [userstoryGraphicDesign])

var task81 = Task.new("Add multiple levels of administrators in the database", 7,
			[["database management", 2]])
var task82 = Task.new("Implement different functionality on the administrator page for different levels of administrators", 8,
			[["web design", 2]])
var task83 = Task.new("Change authentication window to accomodate multiple levels of administrators", 7,
			[["web design", 1], ["computer security", 1]])
var task84 = Task.new("Make green the primary colour of the UI", 3,
			[["graphic design", 2]])
var task85 = Task.new("Add ads on the left side of the page", 3,
			[["web design", 1]])
var task86 = Task.new("Allow customers to edit and delete reviews", 3,
			[["web design", 2], ["database management", 1]])
var userstoryChanges2 = UserStory.new("More design changes story",
	"I am your client and I want some changes made to the design",
	8, [task81, task82, task83, task84, task85, task86], [userstoryGraphicDesign, userstoryDeletion, userstoryFrontPage])
