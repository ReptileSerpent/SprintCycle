extends ScrollContainer

func _ready():
	pass

func update_metrics_charts(day, sprint):
	$"VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/".draw(day, sprint)
	$"VBoxContainer/VelocityVBoxContainer/ScrollContainer/ColorRect/".draw(day, sprint)
	$"VBoxContainer/DevelopersAvailabilityVBoxContainer/ScrollContainer/ColorRect/".draw(day, sprint)
