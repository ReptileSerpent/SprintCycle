extends Panel

var task_class_instance

func _ready():
	$"VBoxContainer/Control/AssignButton".connect("pressed", self, "_on_AssignButton_pressed")

func _on_AssignButton_pressed():
	for developer_node in get_node(@"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI/VBoxContainer").get_children():
		developer_node.showAssignmentButtons()
	get_node(@"/root/Main/ColorRect/VBoxContainer2/MetricsScene").visible = false
	get_node(@"/root/Main/ColorRect/VBoxContainer2/DailyGUI").visible = false
	get_node(@"/root/Main/ColorRect/VBoxContainer2/TasksGUI").visible = false
	
	get_node(@"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").current_task_being_assigned = task_class_instance
	for developerNode in get_node(@"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI/VBoxContainer").get_children():
		if (developerNode.developer_class_instance in task_class_instance.assigned):
			developerNode.get_node("AssignmentButton").pressed = true
			print("found: ", developerNode.developer_class_instance, " ", task_class_instance.assigned)
		else:
			developerNode.get_node("AssignmentButton").pressed = false
			print("not found: ", developerNode.developer_class_instance, " ", task_class_instance.assigned)
		if (developerNode.developer_class_instance in task_class_instance.assigned_temporarily):
			developerNode.get_node("TemporaryAssignmentButton").pressed = true
		else:
			developerNode.get_node("TemporaryAssignmentButton").pressed = false
	
	get_node(@"/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").visible = true
	get_node(@"/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI").visible = false
