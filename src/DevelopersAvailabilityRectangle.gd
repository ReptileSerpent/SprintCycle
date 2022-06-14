extends ColorRect

onready var chart_node = $"DevelopersAvailabilityChart"

func _ready():
	chart_node.initialize(3,
	{
		developers_available = Color(0.58, 0.92, 0.07)
	})
	
	chart_node.set_max_values(21)

func clear_chart():
	chart_node.clear_chart()

func draw(day, sprint):
	if (day >= 7):
		chart_node.create_new_point(
		{
			label = str(sprint),
			values =
			{
			  developers_available = 4
			}
		})
