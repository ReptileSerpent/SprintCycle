extends ColorRect

onready var chart_node = $"VelocityChart"

func _ready():
	chart_node.initialize(3,
	{
		velocity = Color(0.58, 0.92, 0.07)
	})
	
	chart_node.set_max_values(21)

func clear_chart():
	chart_node.clear_chart()

func draw(day, sprint):
	if (day >= 7):
		var completed_userstories_story_points = 0
		for userstory in $"/root/Main".chosen_userstories:
			if (userstory.is_marked_as_completed_in_velocity_chart):
				continue
			var tasks_completed = 0
			for task in userstory.tasks_list:
				if (task.completionPercentage >= 100):
					tasks_completed += 1
			if (tasks_completed == userstory.tasks_list.size()):
				completed_userstories_story_points += userstory.points
				userstory.is_marked_as_completed_in_velocity_chart = true
		
		chart_node.create_new_point(
		{
			label = str(sprint),
			values =
			{
			  velocity = completed_userstories_story_points
			}
		})
