var task_id = 0
var name = ""
var technologies = []
var total_hours_initial_estimation = 5
var completionPercentage = 0
var assigned = null
var assigned_temporarily = null

func _init(name, total_hours_initial_estimation, technologies):
	self.name = name
	self.technologies = technologies
	self.total_hours_initial_estimation = total_hours_initial_estimation
