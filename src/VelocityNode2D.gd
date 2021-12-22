extends Node2D

var day = 1
var sprint = 1
var orange_lines = []
var previous_position = null

func _ready():
	pass

func draw(day, sprint):
	self.day = day
	self.sprint = sprint
	_draw() 

func _draw():
	
	# redrawing previously drawn lines and dots
	for orange_line in orange_lines:
		draw_line(orange_line[0], orange_line[1], Color.orange, 3.0)
		draw_rect(Rect2(orange_line[0].x-3, orange_line[0].y-3, 7, 7), Color.orange, true)
		draw_rect(Rect2(orange_line[1].x-3, orange_line[1].y-3, 7, 7), Color.orange, true)
	
	if (day >= 7):
		print("DRAWING NEW VELOCITY")
		var sprints_earlier_than_10th = min(9, sprint)
		var sprints_equal_or_later_than_10th = max(0, sprint - 9)
		
		var completed_userstories_story_points = 0
		for userstory in get_node("/root/Main").chosenUserStories:
			if (userstory.is_marked_as_completed_in_velocity_chart):
				continue
			var tasks_completed = 0
			for task in userstory.tasksList:
				if (task.completionPercentage >= 100):
					tasks_completed += 1
			if (tasks_completed == userstory.tasksList.size()):
				completed_userstories_story_points += userstory.points
				userstory.is_marked_as_completed_in_velocity_chart = true
		
		var current_position = Vector2(18 * sprints_earlier_than_10th - 18 + 24 * sprints_equal_or_later_than_10th, - 16 * completed_userstories_story_points)
		if (completed_userstories_story_points == 0):
			print("completed_userstories_story_points == 0")
		
		if (previous_position == null):
			draw_rect(Rect2(current_position.x-3, current_position.y-3, 7, 7), Color.orange, true)
			orange_lines.append([current_position, current_position])
			previous_position = current_position
		else:
			draw_line(previous_position, current_position, Color.orange, 3.0)
			draw_rect(Rect2(previous_position.x-3, current_position.y-3, 7, 7), Color.orange, true)
			draw_rect(Rect2(previous_position.x-3, current_position.y-3, 7, 7), Color.orange, true)
			orange_lines.append([previous_position, current_position])
			previous_position = current_position
		day = 1
