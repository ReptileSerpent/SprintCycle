extends Control
var Task = preload("res://src/Task.gd")
var Developer = preload("res://src/Developer.gd")
var UserStory = preload("res://src/UserStory.gd")

func _ready():
	$"VBoxContainer/VBoxContainer2/NewGameButton".connect("pressed", self, "_on_NewGameButton_pressed")
	$"VBoxContainer/VBoxContainer2/HelpButton".connect("pressed", self, "_on_HelpButton_pressed")
	$"VBoxContainer/VBoxContainer2/CreditsButton".connect("pressed", self, "_on_CreditsButton_pressed")
	$"VBoxContainer/VBoxContainer2/SettingsButton".connect("pressed", self, "_on_SettingsButton_pressed")

func _on_NewGameButton_pressed():
	self.visible = false
	$"/root/Main/ColorRect/VBoxContainer2".visible = true
	
	if (!$"/root/Main".game_is_started):
		_prepare_game_state()
		$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Label".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer/Button".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/MetricsScene".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/DailyGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/TasksGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI".visible = false
		$"/root/Main/ColorRect/VBoxContainer2/UserStoriesGUI".visible = true
		$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/MetricsButton".disabled = true
		$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/DevelopersButton".disabled = true
		$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/DailyButton".disabled = true
		$"/root/Main/ColorRect/VBoxContainer2/BottomGUI/TasksButton".disabled = true

func _on_HelpButton_pressed():
	var locale = TranslationServer.get_locale();
	if (locale.substr(0, 2) == "en"):
		$"/root/Main/HelpScreen/HelpRichTextLabel_en".visible = true
		$"/root/Main/HelpScreen/HelpRichTextLabel_ru".visible = false
	elif (locale.substr(0, 2) == "ru"):
		$"/root/Main/HelpScreen/HelpRichTextLabel_en".visible = false
		$"/root/Main/HelpScreen/HelpRichTextLabel_ru".visible = true
	self.visible = false
	$"/root/Main/HelpScreen".visible = true

func _on_SettingsButton_pressed():
	self.visible = false
	if ($"/root/Main".music_is_playing):
		$"/root/Main/Settings/CenterContainer/VBoxContainer/MusicButton".pressed = true
	else:
		$"/root/Main/Settings/CenterContainer/VBoxContainer/MusicButton".pressed = false
	if (TranslationServer.get_locale().substr(0, 2) == "en"):
		$"/root/Main/Settings/CenterContainer/VBoxContainer/VBoxContainer/LanguageOptionButton".select(0)
	elif (TranslationServer.get_locale().substr(0, 2) == "ru"):
		$"/root/Main/Settings/CenterContainer/VBoxContainer/VBoxContainer/LanguageOptionButton".select(1)
	
	$"/root/Main/Settings".visible = true

func _on_CreditsButton_pressed():
	var locale = TranslationServer.get_locale();
	if (locale.substr(0, 2) == "en"):
		$"/root/Main/Credits/CreditsRichTextLabel_en".visible = true
		$"/root/Main/Credits/CreditsRichTextLabel_ru".visible = false
	elif (locale.substr(0, 2) == "ru"):
		$"/root/Main/Credits/CreditsRichTextLabel_en".visible = false
		$"/root/Main/Credits/CreditsRichTextLabel_ru".visible = true
	self.visible = false
	$"/root/Main/Credits".visible = true

func _on_MusicButton_pressed():
	if ($"/root/Main".music_is_playing):
		$"/root/Main".music_is_playing = false
		$"/root/Main/Music".stop()
	else:
		$"/root/Main".music_is_playing = true
		$"/root/Main/Music".play()

func _prepare_game_state():
	
	$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer".sprint = 1
	$"/root/Main/ColorRect/VBoxContainer2/TopGUI/HBoxContainer".day = 1
	
	$"/root/Main/ColorRect/VBoxContainer2/MetricsScene/VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/".clear_chart()
	$"/root/Main/ColorRect/VBoxContainer2/MetricsScene/VBoxContainer/VelocityVBoxContainer/ScrollContainer/ColorRect/".clear_chart()
	$"/root/Main/ColorRect/VBoxContainer2/MetricsScene/VBoxContainer/DevelopersAvailabilityVBoxContainer/ScrollContainer/ColorRect/".clear_chart()
	
	for node in $"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI/VBoxContainer".get_children():
		node.queue_free()
	
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
	
	var developers = []
	var userstories = []
	
	developers.append(Developer.new(names_chosen[0], 85, 20,
		[["database management", 3], ["system administration", 3], ["computer security", 2]]))
	developers.append(Developer.new(names_chosen[1], 70, 20,
		[["graphic design", 2], ["web design", 2]]))
	developers.append(Developer.new(names_chosen[2], 80, 40,
		[["database management", 1], ["web design", 1], ["computer security", 2]]))
	developers.append(Developer.new(names_chosen[3], 85, 20,
		[["database management", 1], ["computer security", 2]]))
	
	for developer in developers:
		var developer_scene = load("src/DeveloperScene.tscn").instance()
		developer_scene.developer_class_instance = developer
		print(developer_scene.developer_class_instance)
		developer_scene.get_node("NameLabel").text = developer.name
		developer_scene.get_node("QualificationsLabel").text = PoolStringArray(developer.known_technologies).join(" ")
		developer_scene.get_node("MoraleLabel").text = "Morale: " + str(developer.morale)
		developer_scene.get_node("ResigningLabel").text = "resigning in " + str(developer.sprints_before_resigning) + " sprints"
		developer_scene.get_node("TotalTasksLabel").text = "Currently assigned to 0 tasks\n(0 temporarily)"
		$"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI/VBoxContainer".add_child(developer_scene)
	
	$"/root/Main/".developers = developers
	
	var task01 = Task.new(tr("USERSTORYCONCEPT_TASK01_NAME"), 1,
			[["system administration", 1], ["database management", 2]])
	var task02 = Task.new(tr("USERSTORYCONCEPT_TASK02_NAME"), 3,
				[["database management", 2]])
	var task03 = Task.new(tr("USERSTORYCONCEPT_TASK03_NAME"), 2,
				[["database management", 1]])
	var task04 = Task.new(tr("USERSTORYCONCEPT_TASK04_NAME"), 2,
				[["database management", 1]])
	var task05 = Task.new(tr("USERSTORYCONCEPT_TASK05_NAME"), 3,
				[["database management", 1], ["computer security", 2]])
	var task06 = Task.new(tr("USERSTORYCONCEPT_TASK06_NAME"), 8,
				[["web design", 2]])
	var task07 = Task.new(tr("USERSTORYCONCEPT_TASK07_NAME"), 8,
				[["web design", 2]])
	var task08 = Task.new(tr("USERSTORYCONCEPT_TASK08_NAME"), 2,
				[["database management", 2]])
	var userstoryConcept = UserStory.new(tr("USERSTORYCONCEPT_NAME"),
		tr("USERSTORYCONCEPT_DESCRIPTION"),
		8, [task01, task02, task03, task04, task05, task06, task07, task08], [])
	
	var task11 = Task.new(tr("USERSTORYAUTH_TASK01_NAME"), 3,
				[["web design", 1], ["computer security", 2]])
	var task12 = Task.new(tr("USERSTORYAUTH_TASK02_NAME"), 3,
				[["web design", 1], ["computer security", 2]])
	var task13 = Task.new(tr("USERSTORYAUTH_TASK03_NAME"), 5,
				[["web design", 1], ["database management", 1]])
	var task14 = Task.new(tr("USERSTORYAUTH_TASK04_NAME"), 5,
				[["web design", 1], ["database management", 1]])
	var task15 = Task.new(tr("USERSTORYAUTH_TASK05_NAME"), 5,
				[["web design", 2]])
	var userstoryAuth = UserStory.new(tr("USERSTORYAUTH_NAME"),
		tr("USERSTORYAUTH_DESCRIPTION"),
		5, [task11, task12, task13, task14, task15], [userstoryConcept])

	var task21 = Task.new(tr("USERSTORYADMIN_TASK01_NAME"), 2,
				[["database management", 1]])
	var task22 = Task.new(tr("USERSTORYADMIN_TASK02_NAME"), 3,
				[["web design", 1]])
	var task23 = Task.new(tr("USERSTORYADMIN_TASK03_NAME"), 6,
				[["web design", 1]])
	var task24 = Task.new(tr("USERSTORYADMIN_TASK04_NAME"), 6,
				[["web design", 1]])
	var task25 = Task.new(tr("USERSTORYADMIN_TASK05_NAME"), 5,
				[["web design", 1], ["computer security", 1]])
	var userstoryAdmin = UserStory.new(tr("USERSTORYADMIN_NAME"),
		tr("USERSTORYADMIN_DESCRIPTION"),
		5, [task21, task22, task23, task24, task25], [userstoryConcept])

	var task31 = Task.new(tr("USERSTORYREVIEWS_TASK01_NAME"), 5,
				[["database management", 2]])
	var task32 = Task.new(tr("USERSTORYREVIEWS_TASK02_NAME"), 3,
				[["web design", 2]])
	var task33 = Task.new(tr("USERSTORYREVIEWS_TASK03_NAME"), 5,
				[["web design", 3]])
	var userstoryReviews = UserStory.new(tr("USERSTORYREVIEWS_NAME"),
		tr("USERSTORYREVIEWS_DESCRIPTION"),
		3, [task31, task32, task33], [userstoryAuth])

	var task41 = Task.new(tr("USERSTORYDELETION_TASK01_NAME"), 3,
				[["database management", 2]])
	var task42 = Task.new(tr("USERSTORYDELETION_TASK02_NAME"), 3,
				[["web design", 1]])
	var task43 = Task.new(tr("USERSTORYDELETION_TASK03_NAME"), 2,
				[["web design", 2]])
	var task44 = Task.new(tr("USERSTORYDELETION_TASK04_NAME"), 3,
				[["web design", 2]])
	var userstoryDeletion = UserStory.new(tr("USERSTORYDELETION_NAME"),
		tr("USERSTORYDELETION_DESCRIPTION"),
		3, [task41, task42, task43, task44], [userstoryAuth])

	var task51 = Task.new(tr("USERSTORYFRONTPAGE_TASK01_NAME"), 8,
				[["web design", 2]])
	var task52 = Task.new(tr("USERSTORYFRONTPAGE_TASK02_NAME"), 5,
				[["web design", 1]])
	var task53 = Task.new(tr("USERSTORYFRONTPAGE_TASK03_NAME"), 2,
				[["web design", 2]])
	var task54 = Task.new(tr("USERSTORYFRONTPAGE_TASK04_NAME"), 3,
				[["web design", 3]])
	var userstoryFrontPage = UserStory.new(tr("USERSTORYFRONTPAGE_NAME"),
		tr("USERSTORYFRONTPAGE_DESCRIPTION"),
		8, [task51, task52, task53, task54], [userstoryAdmin])

	var task61 = Task.new(tr("USERSTORYGRAPHICDESIGN_TASK01_NAME"), 1,
				[["graphic design", 1]])
	var task62 = Task.new(tr("USERSTORYGRAPHICDESIGN_TASK02_NAME"), 2,
				[["graphic design", 2]])
	var task63 = Task.new(tr("USERSTORYGRAPHICDESIGN_TASK03_NAME"), 10,
				[["graphic design", 2]])
	var task64 = Task.new(tr("USERSTORYGRAPHICDESIGN_TASK04_NAME"), 20,
				[["web design", 2]])
	var userstoryGraphicDesign = UserStory.new(tr("USERSTORYGRAPHICDESIGN_NAME"),
		tr("USERSTORYGRAPHICDESIGN_DESCRIPTION"),
		8, [task61, task62, task63, task64], [userstoryReviews])

	var task71 = Task.new(tr("USERSTORYCHANGES1_TASK01_NAME"), 2,
				[["web design", 1]])
	var task72 = Task.new(tr("USERSTORYCHANGES1_TASK02_NAME"), 3,
				[["web design", 2]])
	var task73 = Task.new(tr("USERSTORYCHANGES1_TASK03_NAME"), 3,
				[["web design", 1]])
	var task74 = Task.new(tr("USERSTORYCHANGES1_TASK04_NAME"), 5,
				[["database management", 2]])
	var task75 = Task.new(tr("USERSTORYCHANGES1_TASK05_NAME"), 6,
				[["web design", 2]])
	var task76 = Task.new(tr("USERSTORYCHANGES1_TASK06_NAME"), 2,
				[["web design", 1], ["database management", 1]])
	var task77 = Task.new(tr("USERSTORYCHANGES1_TASK07_NAME"), 3,
				[["system administration", 3], ["database management"], 1])
	var userstoryChanges1 = UserStory.new(tr("USERSTORYCHANGES1_NAME"),
		tr("USERSTORYCHANGES1_DESCRIPTION"),
		8, [task71, task72, task73, task74, task75, task76, task77], [userstoryGraphicDesign])

	var task81 = Task.new(tr("USERSTORYCHANGES2_TASK01_NAME"), 7,
				[["database management", 2]])
	var task82 = Task.new(tr("USERSTORYCHANGES2_TASK02_NAME"), 8,
				[["web design", 2]])
	var task83 = Task.new(tr("USERSTORYCHANGES2_TASK03_NAME"), 7,
				[["web design", 1], ["computer security", 1]])
	var task84 = Task.new(tr("USERSTORYCHANGES2_TASK04_NAME"), 3,
				[["graphic design", 2]])
	var task85 = Task.new(tr("USERSTORYCHANGES2_TASK05_NAME"), 3,
				[["web design", 1]])
	var task86 = Task.new(tr("USERSTORYCHANGES2_TASK06_NAME"), 3,
				[["web design", 2], ["database management", 1]])
	var userstoryChanges2 = UserStory.new(tr("USERSTORYCHANGES2_NAME"),
		tr("USERSTORYCHANGES2_DESCRIPTION"),
		8, [task81, task82, task83, task84, task85, task86], [userstoryGraphicDesign, userstoryDeletion, userstoryFrontPage])
	
	# class Bug: extends Task
	#	var preceding_task

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
	
	userstories.append(userstoryConcept)
	userstories.append(userstoryAuth)
	userstories.append(userstoryAdmin)
	userstories.append(userstoryReviews)
	userstories.append(userstoryDeletion)
	userstories.append(userstoryFrontPage)
	userstories.append(userstoryGraphicDesign)
	userstories.append(userstoryChanges1)
	userstories.append(userstoryChanges2)
	
	$"/root/Main/".userstories = userstories
	
	$"/root/Main/".set_available_userstories()

func _process(delta):
	$"VBoxContainer/CycleSprite".set_rotation_degrees($"VBoxContainer/CycleSprite".rotation_degrees + 120 * delta)
	if ($"VBoxContainer/CycleSprite".get_rotation_degrees() > 360):
		$"VBoxContainer/CycleSprite".set_rotation_degrees($"VBoxContainer/CycleSprite".rotation_degrees - 360)	# prevents overflow
