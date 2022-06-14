extends ColorRect

onready var chart_node = $"SprintBurndownChart"

func _ready():
	chart_node.initialize(3,
	{
		timely_burndown = Color(0.58, 0.92, 0.07),
		actual_burndown = Color(1.0, 0.18, 0.18)
	})
	
	chart_node.set_max_values(21)

var story_points_left = 0
var completed_userstories_story_points = 0

func clear_chart():
	chart_node.clear_chart()

func set_values_for_start_of_new_sprint():
	var total_sprint_story_points = 0
	for userstory in $"/root/Main".chosen_userstories:
		total_sprint_story_points += userstory.points
	
	story_points_left = total_sprint_story_points
	completed_userstories_story_points = 0

func draw(day, sprint):
	var days_since_start = (sprint - 1) * 7 + day
	var total_sprint_story_points = 0
	for userstory in $"/root/Main".chosen_userstories:
		total_sprint_story_points += userstory.points
	
	var currently_completed_userstories_story_points = 0
	for userstory in $"/root/Main".chosen_userstories:
		var tasks_completed = 0
		for task in userstory.tasks_list:
			if (task.completionPercentage >= 100):
				tasks_completed += 1
		if (tasks_completed == userstory.tasks_list.size()):
			currently_completed_userstories_story_points += userstory.points
	
	var newly_completed_userstories_story_points = currently_completed_userstories_story_points - completed_userstories_story_points
	
	story_points_left -= newly_completed_userstories_story_points
	
	chart_node.create_new_point(
	{
		label = str(days_since_start),
		values =
		{
			timely_burndown = (7 - day) / 6.0 * total_sprint_story_points,
			actual_burndown = story_points_left
		}
	})
	
	completed_userstories_story_points += newly_completed_userstories_story_points
