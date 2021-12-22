extends HBoxContainer

func _ready():
	$MetricsButton.connect("pressed", self, "_on_MetricsButton_pressed")
	$DevelopersButton.connect("pressed", self, "_on_DevelopersButton_pressed")
	$DailyButton.connect("pressed", self, "_on_DailyButton_pressed")
	$TasksButton.connect("pressed", self, "_on_TasksButton_pressed")

func _on_MetricsButton_pressed():
	get_node("ClickSound").play()
	get_node(@"../MetricsScene").visible = true;
	get_node(@"../DailyGUI").visible = false;
	get_node(@"../TasksGUI").visible = false;
	get_node(@"../DevelopersGUI").visible = false;
	get_node(@"../CourseEnrollmentGUI").visible = false;

func _on_DevelopersButton_pressed():
	get_node("ClickSound").play()
	get_node(@"../MetricsScene").visible = false;
	get_node(@"../DailyGUI").visible = false;
	get_node(@"../TasksGUI").visible = false;
	get_node(@"../DevelopersGUI").visible = true;
	get_node(@"../CourseEnrollmentGUI").visible = false;
	for developer_node in get_node(@"../DevelopersGUI/VBoxContainer").get_children():
		developer_node.hideAssignmentButtons()

func _on_DailyButton_pressed():
	get_node("ClickSound").play()
	get_node(@"../MetricsScene").visible = false;
	get_node(@"../DailyGUI").visible = true;
	get_node(@"../TasksGUI").visible = false;
	get_node(@"../DevelopersGUI").visible = false;
	get_node(@"../CourseEnrollmentGUI").visible = false;
	
func _on_TasksButton_pressed():
	get_node("ClickSound").play()
	get_node(@"../MetricsScene").visible = false;
	get_node(@"../DailyGUI").visible = false;
	get_node(@"../TasksGUI").visible = true;
	get_node(@"../DevelopersGUI").visible = false;
	get_node(@"../CourseEnrollmentGUI").visible = false;
