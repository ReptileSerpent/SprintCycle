extends ScrollContainer

func _ready():
	pass

func update_metrics_charts(day, sprint):
	get_node("VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/SprintBurndownNode2D").draw(day, sprint)
	get_node("VBoxContainer/VelocityVBoxContainer/ScrollContainer/ColorRect/VelocityNode2D").draw(day, sprint)
	get_node("VBoxContainer/DevelopersAvailabilityVBoxContainer/ScrollContainer/ColorRect/DevelopersAvailabilityNode2D").draw(day, sprint)
	# get_node("VBoxContainer/VelocityVBoxContainer/ScrollContainer/ColorRect/VelocityNode2D").draw(day, sprint)
	# get_node("VBoxContainer/DevelopersAvailabilityVBoxContainer/ScrollContainer/ColorRect/DevelopersAvailabilityNode2D").draw(day, sprint)
	
#	var vector = Vector2(0, 0)
#	get_node("VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/SprintBurndownLine2D").add_point(vector)
#	get_node("VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/SprintBurndownLine2D").width = 3.0
#	get_node("VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/SprintBurndownLine2D").default_color = Color.orange
#	get_node("VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/SprintBurndownLine2D").begin_cap_mode = 1
#	get_node("VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/SprintBurndownLine2D").end_cap_mode = 1
#	for i in range(1, 9):
#		vector.x += 18
#		vector.y *= -1
#		get_node("VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/SprintBurndownLine2D").add_point(vector)
#	for i in range(10, 100):
#		vector.x += 24
#		vector.y *= -1
#		get_node("VBoxContainer/SprintBurndownVBoxContainer/ScrollContainer/ColorRect/SprintBurndownLine2D").add_point(vector)
#	
#	var vector2 = Vector2(0, 5)
#	get_node("VBoxContainer/VelocityVBoxContainer/ScrollContainer/ColorRect/VelocityLine2D").add_point(vector2)
#	get_node("VBoxContainer/VelocityVBoxContainer/ScrollContainer/ColorRect/VelocityLine2D").width = 3.0
#	get_node("VBoxContainer/VelocityVBoxContainer/ScrollContainer/ColorRect/VelocityLine2D").default_color = Color.orange
#	for i in range(1, 9):
#		vector2.x += 18
#		vector2.y *= -1
#		get_node("VBoxContainer/VelocityVBoxContainer/ScrollContainer/ColorRect/VelocityLine2D").add_point(vector2)
#	for i in range(10, 100):
#		vector2.x += 24
#		vector2.y *= -1
#		get_node("VBoxContainer/VelocityVBoxContainer/ScrollContainer/ColorRect/VelocityLine2D").add_point(vector2)
#	
#	var vector3 = Vector2(0, 5)
#	get_node("VBoxContainer/DevelopersAvailabilityVBoxContainer/ScrollContainer/ColorRect/DevelopersAvailabilityLine2D").add_point(vector3)
#	get_node("VBoxContainer/DevelopersAvailabilityVBoxContainer/ScrollContainer/ColorRect/DevelopersAvailabilityLine2D").width = 3.0
#	get_node("VBoxContainer/DevelopersAvailabilityVBoxContainer/ScrollContainer/ColorRect/DevelopersAvailabilityLine2D").default_color = Color.orange
#	for i in range(1, 9):
#		vector3.x += 18
#		vector3.y *= -1
#		get_node("VBoxContainer/DevelopersAvailabilityVBoxContainer/ScrollContainer/ColorRect/DevelopersAvailabilityLine2D").add_point(vector3)
#	for i in range(10, 100):
#		vector3.x += 24
#		vector3.y *= -1
#		get_node("VBoxContainer/DevelopersAvailabilityVBoxContainer/ScrollContainer/ColorRect/DevelopersAvailabilityLine2D").add_point(vector3)
