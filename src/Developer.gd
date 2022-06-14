var name = ""
var morale = 100
var known_technologies = [["networking", 2],
							["server architecture", 1]]
var tasks_completed_yesterday = []
var task_stuck_on
func set_morale(value):
	morale = value
	if value > 100:
		morale = 100
	elif value < 0:
		morale = 0

var time_left = 8
var is_stuck_on_task = false
var technology_is_unfamiliar = false
var technology_is_very_unfamiliar = false
var isIll = false
var isStudying = false
var isOnVacation = false
var isResigning = false
var illnessDaysRemaining = 0
var studyingDaysRemaining = 0
var vacationDaysRemaining = 0
var sprints_before_resigning = 0
var technologyBeingStudied = ""

func _init(name, morale, sprints_before_resigning, known_technologies):
	self.name = name
	self.morale = morale
	self.sprints_before_resigning = sprints_before_resigning
	self.known_technologies = known_technologies
