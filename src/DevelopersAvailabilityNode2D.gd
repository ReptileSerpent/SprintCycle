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
		print("DRAWING NEW DEVELOPERS AVAILABILITY")
		var sprints_earlier_than_10th = min(9, sprint)
		var sprints_equal_or_later_than_10th = max(0, sprint - 9)
		
		var current_position = Vector2(18 * sprints_earlier_than_10th - 18 + 24 * sprints_equal_or_later_than_10th, - 16 * 4)
		
		if (previous_position == null):
			draw_rect(Rect2(current_position.x-3, current_position.y-3, 7, 7), Color.orange, true)
			orange_lines.append([current_position, current_position])
			previous_position = current_position
		else:
			draw_line(previous_position, current_position, Color.orange, 3.0)
			draw_rect(Rect2(previous_position.x-3, current_position.y-3, 7, 7), Color.orange, true )
			draw_rect(Rect2(previous_position.x-3, current_position.y-3, 7, 7), Color.orange, true)
			orange_lines.append([previous_position, current_position])
			previous_position = current_position
		day = 1
