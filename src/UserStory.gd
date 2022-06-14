var user_story_id = 0
var name = "Account cancellation story"
var description = "I am a customer and I want a 'cancel account' button so I can cancel my account"
var tasks_list = []
var points = 5
var parent_user_stories = []
var is_marked_as_completed_in_velocity_chart = false

func _init(name, description, points, tasks_list, parent_user_stories):
	self.name = name
	self.description = description
	self.points = points
	self.tasks_list = tasks_list
	self.parent_user_stories = parent_user_stories
