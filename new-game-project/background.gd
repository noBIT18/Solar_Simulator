extends Node2D

func _draw() -> void:
	for i in range(1, 1000):
		var r = randi_range(0, 255)
		var b = randi_range(0, 255)
		var white = randi_range(0, 2)
		var grow
		var color
		if white <= 0:
			grow = randi_range(1,2)
			color = Color8(255,255,255)
		elif r <= b:
			grow = randi_range(1,5)
			color = Color8(0,0,b)
		elif b <= r:
			grow = randi_range(1,5)
			color = Color8(r,0,0)
		draw_circle(Vector2(randi_range(-2000, 1500), randi_range(960, -960)),grow, color)

func _process(delta: float) -> void:
	print(global_position)
	position = global_position + Vector2(0.01,0)
