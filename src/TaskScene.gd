extends Panel

var task_class_instance
var previous_developer_index = 0
var previous_temporary_help_index = 0

func _ready():
	$"VBoxContainer/Control/DeveloperOptionButton".connect("item_selected", self, "_on_DeveloperOptionButton_item_selected")
	$"VBoxContainer/Control/TemporaryHelpOptionButton".connect("item_selected", self, "_on_TemporaryHelpOptionButton_item_selected")	

func _on_DeveloperOptionButton_item_selected(index):
	if (index == 0):
		task_class_instance.assigned = null
	else:
		$"VBoxContainer/Control/TemporaryHelpOptionButton".set_item_disabled(index, true)
		task_class_instance.assigned = $"/root/Main/".developers[index - 1]
	$"VBoxContainer/Control/TemporaryHelpOptionButton".set_item_disabled(previous_developer_index, false)
	previous_developer_index = index

func _on_TemporaryHelpOptionButton_item_selected(index):
	if (index == 0):
		task_class_instance.assigned_temporarily = null
	else:
		$"VBoxContainer/Control/DeveloperOptionButton".set_item_disabled(index, true)
		task_class_instance.assigned_temporarily = $"/root/Main/".developers[index - 1]
	$"VBoxContainer/Control/DeveloperOptionButton".set_item_disabled(previous_temporary_help_index, false)
	previous_temporary_help_index = index
