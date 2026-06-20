extends Node2D

@export var mass = randi_range(1, 10)
var temperature: int

const STAR_TYPES = [
	{"class": "O", "color": Color(0.4, 0.6, 1.0), "base_radius": 140.0},
	{"class": "B", "color": Color(0.6, 0.75, 1.0), "base_radius": 110.0},
	{"class": "A", "color": Color(0.9, 0.95, 1.0), "base_radius": 85.0},
	{"class": "F", "color": Color(1.0, 1.0, 0.9), "base_radius": 65.0},
	{"class": "G", "color": Color(1.0, 0.95, 0.7), "base_radius": 50.0},
	{"class": "K", "color": Color(1.0, 0.7, 0.4), "base_radius": 40.0},
	{"class": "M", "color": Color(1.0, 0.35, 0.15), "base_radius": 25.0}
]

var planets: Array = []
var star_radius: float = 50.0

func _ready() -> void:
	reroll()

func reroll():
	planets.clear()
	temperature = randi_range(1, 10)
	
	var star_type_index = get_star_type_index()
	var base_radius = STAR_TYPES[star_type_index]["base_radius"]
	star_radius = base_radius * pow(float(mass), 0.8)
	
	generate_planets()
	queue_redraw()

func _process(delta: float) -> void:
	for planet in planets:
		planet["angle"] += planet["speed"] * delta
		planet["angle"] = fmod(planet["angle"], TAU)
		
	queue_redraw()

func generate_planets():
	var num_planets = randi_range(3, 6)
	var current_distance = star_radius + 60.0 
	
	for i in range(num_planets):
		var orbital_period = sqrt(pow(current_distance, 3) / float(mass))
		var speed_modifier = 2500.0 / orbital_period
		
		var new_planet = {
			"distance": current_distance,
			"angle": randf_range(0, TAU),
			"speed": speed_modifier,
			"radius": randf_range(6.0, 18.0),
			"color": Color(randf_range(0.2, 0.9), randf_range(0.2, 0.9), randf_range(0.2, 0.9))
		}
		
		planets.append(new_planet)
		
		current_distance += randf_range(70.0, 120.0)

func get_star_type_index() -> int:
	if temperature >= 10: return 0
	elif temperature >= 8: return 1
	elif temperature >= 6: return 2
	elif temperature >= 4: return 3
	elif temperature >= 3: return 4
	elif temperature >= 2: return 5
	else: return 6

func _draw() -> void:
	var star_type_index = get_star_type_index()
	var star_color = STAR_TYPES[star_type_index]["color"]
	
	var glow_color = star_color
	glow_color.a = 0.12
	draw_circle(Vector2(0, 0), star_radius * 1.3, glow_color)
	draw_circle(Vector2(0, 0), star_radius * 1.15, glow_color)
	
	draw_circle(Vector2(0, 0), star_radius, star_color)
	
	for planet in planets:
		draw_arc(Vector2(0,0), planet["distance"], 0, TAU, 120, Color(1, 1, 1, 0.07), 1.0)
		
		var planet_pos = Vector2(
			planet["distance"] * cos(planet["angle"]),
			planet["distance"] * sin(planet["angle"])
		)
		
		draw_circle(planet_pos, planet["radius"], planet["color"])
