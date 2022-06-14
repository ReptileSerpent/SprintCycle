extends HBoxContainer

func _ready():
	$MetricsButton.connect("pressed", self, "_on_MetricsButton_pressed")
	$DevelopersButton.connect("pressed", self, "_on_DevelopersButton_pressed")
	$DailyButton.connect("pressed", self, "_on_DailyButton_pressed")
	$TasksButton.connect("pressed", self, "_on_TasksButton_pressed")

func _on_MetricsButton_pressed():
	$"ClickSound".play()
	$"../MetricsScene".visible = true;
	$"../DailyGUI".visible = false;
	$"../TasksGUI".visible = false;
	$"../DevelopersGUI".visible = false;
	$"../CourseEnrollmentGUI".visible = false;

func _on_DevelopersButton_pressed():
	$"ClickSound".play()
	$"../MetricsScene".visible = false;
	$"../DailyGUI".visible = false;
	$"../TasksGUI".visible = false;
	$"../DevelopersGUI".visible = true;
	$"../CourseEnrollmentGUI".visible = false;
	for developer_node in $"../DevelopersGUI/VBoxContainer".get_children():
		developer_node.hideAssignmentButtons()

func _on_DailyButton_pressed():
	$"ClickSound".play()
	$"../MetricsScene".visible = false;
	$"../DailyGUI".visible = true;
	$"../TasksGUI".visible = false;
	$"../DevelopersGUI".visible = false;
	$"../CourseEnrollmentGUI".visible = false;
	
func _on_TasksButton_pressed():
	$"ClickSound".play()
	$"../MetricsScene".visible = false;
	$"../DailyGUI".visible = false;
	$"../TasksGUI".visible = true;
	$"../DevelopersGUI".visible = false;
	$"../CourseEnrollmentGUI".visible = false;
