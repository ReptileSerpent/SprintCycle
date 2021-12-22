extends Panel

var developer_class_instance

func _ready():
	$"VacationOfferButton".connect("pressed", self, "_on_VacationOfferButton_pressed")
	$"CourseEnrollmentButton".connect("pressed", self, "_on_CourseEnrollmentButton_pressed")
	$"AssignmentButton".connect("toggled", self, "_on_AssignmentButton_toggled")
	$"TemporaryAssignmentButton".connect("toggled", self, "_on_TemporaryAssignmentButton_toggled")

func _on_VacationOfferButton_pressed():
	get_node("/root/Main/PopupPanel").visible = true

func _on_CourseEnrollmentButton_pressed():
	$"../..".visible = false
	get_node("/root/Main/ColorRect/VBoxContainer2/CourseEnrollmentGUI").visible = true

func _on_AssignmentButton_toggled(button_pressed):
	print("TOGGLED TO: ", str(button_pressed))
	if (button_pressed):
		$"TemporaryAssignmentButton".pressed = false
		get_node("/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").current_task_being_assigned.assigned.append(developer_class_instance)
		get_node("/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").current_task_being_assigned.assigned_temporarily.erase(developer_class_instance)
	else:
		get_node("/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").current_task_being_assigned.assigned.erase(developer_class_instance)

func _on_TemporaryAssignmentButton_toggled(button_pressed):
	if (button_pressed):
		$"AssignmentButton".pressed = false
		get_node("/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").current_task_being_assigned.assigned_temporarily.append(developer_class_instance)
		get_node("/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").current_task_being_assigned.assigned.erase(developer_class_instance)
	else:
		get_node("/root/Main/ColorRect/VBoxContainer2/DevelopersGUI").current_task_being_assigned.assigned_temporarily.erase(developer_class_instance)

func hideAssignmentButtons():
	$"AssignmentButton".visible = false
	$"TemporaryAssignmentButton".visible = false

func showAssignmentButtons():
	$"AssignmentButton".visible = true
	$"TemporaryAssignmentButton".visible = true
