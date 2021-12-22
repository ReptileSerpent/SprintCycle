extends Node2D

var is_first_draw = true

var day = 1
var sprint = 1
var story_points_left = 0
var green_lines = []
var orange_lines = []
var completed_userstories_story_points = 0
var drew_vertical_line = false

func _ready():
	pass

func draw(day, sprint):
	self.day = day
	self.sprint = sprint
	_draw() 

func _draw():
	
	# redrawing previously drawn lines and dots
	for green_line in green_lines:
		draw_line(green_line[0], green_line[1], Color.green, 3.0)
		draw_rect(Rect2(green_line[0].x-3, green_line[0].y-3, 7, 7), Color.green, true)
		draw_rect(Rect2(green_line[1].x-3, green_line[1].y-3, 7, 7), Color.green, true)
	for orange_line in orange_lines:
		draw_line(orange_line[0], orange_line[1], Color.orange, 3.0)
		draw_rect(Rect2(orange_line[0].x-3, orange_line[0].y-3, 7, 7), Color.orange, true)
		draw_rect(Rect2(orange_line[1].x-3, orange_line[1].y-3, 7, 7), Color.orange, true)
	
	var days_since_start = (sprint - 1) * 7 + day
	var days_earlier_than_10th = min(9, days_since_start)
	var days_equal_or_later_than_10th = max(0, days_since_start - 9)
	
	var sprint_end_day = days_since_start + 6
	var sprint_end_day_days_earlier_than_10th = min(9, sprint_end_day)
	var sprint_end_day_days_equal_or_later_than_10th = max(0, sprint_end_day - 9)
	
	var current_position = Vector2(18 * days_earlier_than_10th - 18 + 24 * days_equal_or_later_than_10th, 0)
	var sprint_end_position = Vector2(18 * sprint_end_day_days_earlier_than_10th - 18 + 24 * sprint_end_day_days_equal_or_later_than_10th, 0)
	
	if (day == 1):		# is start of a new sprint
		completed_userstories_story_points = 0
		
		# getting story points amount
		var total_sprint_story_points = 0
		for userstory in get_node("/root/Main").chosenUserStories:
			total_sprint_story_points += userstory.points
		story_points_left = total_sprint_story_points
		
		var vector1 = Vector2(current_position.x, - total_sprint_story_points * 16)
		var vector2 = Vector2(sprint_end_position.x, 0)
		
		draw_line(vector1, vector2, Color.green, 3.0)
		green_lines.append([vector1, vector2])
		draw_rect(Rect2(vector1.x-3, vector1.y-3, 7, 7), Color.green, true)
		draw_rect(Rect2(vector2.x-3, vector2.y-3, 7, 7), Color.green, true)
	elif (!is_first_draw):
		var previous_day_days_since_start = days_since_start - 1
		var previous_day_days_earlier_than_10th = min(9, previous_day_days_since_start)
		var previous_day_days_equal_or_later_than_10th = max(0, previous_day_days_since_start - 9)
		var previous_day_position = Vector2(18 * previous_day_days_earlier_than_10th - 18 + 24 * previous_day_days_equal_or_later_than_10th, 0)
		
		if (!drew_vertical_line):
			var vector1 = Vector2(previous_day_position.x, - story_points_left * 16)
			var vector2 = Vector2(current_position.x, - story_points_left * 16)
			draw_line(vector1, vector2, Color.orange, 3.0)
			draw_rect(Rect2(vector1.x-3, vector1.y-3, 7, 7), Color.orange, true)
			draw_rect(Rect2(vector2.x-3, vector2.y-3, 7, 7), Color.orange, true)
			orange_lines.append([vector1, vector2])
		else:
			drew_vertical_line = false
		
		var currently_completed_userstories_story_points = 0
		for userstory in get_node("/root/Main").chosenUserStories:
			var tasks_completed = 0
			for task in userstory.tasksList:
				if (task.completionPercentage >= 100):
					tasks_completed += 1
			if (tasks_completed == userstory.tasksList.size()):
				currently_completed_userstories_story_points += userstory.points
		
		var newly_completed_userstories_story_points = currently_completed_userstories_story_points - completed_userstories_story_points
		
		# whether should draw a vertical line
		if (newly_completed_userstories_story_points > 0):
			var vertical_vector1 = Vector2(current_position.x, - story_points_left * 16)
			var vertical_vector2 = Vector2(current_position.x, - story_points_left * 16 + newly_completed_userstories_story_points * 16)
			draw_line(vertical_vector1, vertical_vector2, Color.orange, 3.0)
			draw_rect(Rect2(vertical_vector1.x-3, vertical_vector1.y-3, 7, 7), Color.orange, true)
			draw_rect(Rect2(vertical_vector2.x-3, vertical_vector2.y-3, 7, 7), Color.orange, true)
			orange_lines.append([vertical_vector1, vertical_vector2])
			drew_vertical_line = true
		
		story_points_left -= newly_completed_userstories_story_points
		completed_userstories_story_points += newly_completed_userstories_story_points
	
	is_first_draw = false
	
#	var vectors = []
#	var vector = (Vector2(0, 0))
#	vectors.append(vector)
#	draw_rect(Rect2(vectors[0].x-3, vectors[0].y-3, 7, 7), Color.orange, true)
#	
#	if (is_first_draw):
#		is_first_draw = false
#	else:
#		draw_rect(Rect2(vectors[0].x, vectors[0].y-30, 20, 20), Color.orange, true)
#	
#	for i in range(1, 10):
#		vector.x += 18
#		vector.y -= 18
#		vectors.append(vector)
#	for i in range(10, 100):
#		vector.x += 24
#		vector.y -= 18
#		vectors.append(vector)
#	
#	for i in range(0, 99):
#		draw_line(vectors[i], vectors[i+1], Color.orange, 3.0)
#		draw_rect(Rect2(vectors[i].x-3, vectors[i].y-3, 7, 7), Color.orange, true)
